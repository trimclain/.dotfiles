--[[
System Requirements:
  - awk (gawk)
  - pactl (libpulse) or wpctl (wireplumber)
]]

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local poll_timeout = 1

local volume_icons = { "", "", "󰕾", " " }
local volume_up_icon = ""
local volume_down_icon = ""
local volume_muted_icon = "󰖁"
local volume_unmuted_icon = "󰕾"
local microphone_muted_icon = "󰍭" -- "", ""
local microphone_unmuted_icon = ""
local headphones_muted_icon = volume_muted_icon -- "󰟎"
local headphones_unmuted_icon = "" -- "󰋋"

local volume_notification_id = nil
local volume_text = nil
local volume_widget = nil
local widget_refresh_timer = nil -- wpctl fallback only

local monitoring_started = false
local subscription_pid = nil
local retry_timer = nil
local event_refresh_timer = nil
local stopping = false
local refresh_generation = 0
local start_monitoring -- Defined below, called after backend detection.

local volumectl = "pactl"
local get_volume_cmd = "LC_ALL=C pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | awk -F '%' '{ print $1 }'"
local get_volume_muted_status_cmd = "LC_ALL=C pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'"
local get_micro_muted_status_cmd = "LC_ALL=C pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'"
local get_headphones_connected_status_cmd = [=[
    sink=$(LC_ALL=C pactl get-default-sink) &&
    LC_ALL=C pactl list sinks | awk -v sink="$sink" '
        /^[[:space:]]*Name:/ { selected = ($2 == sink) }
        selected && /Active Port:/ { print $3; exit }
    '
]=]

local volume_up_cmd = "pactl set-sink-volume @DEFAULT_SINK@ +5%"
local volume_down_cmd = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
local volume_unmute_cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0"
local volume_mute_toggle_cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
local micro_mute_toggle_cmd = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"

--- Send a critical notification
---@param msg string notification text
local function gg(msg)
    utils.notify(msg, { preset = "critical", title = "Awesome Volume Error", timeout = 5 })
end

--- Stop monitoring and invalidate any outstanding display refreshes
local function stop_monitoring()
    monitoring_started = false
    refresh_generation = refresh_generation + 1

    if widget_refresh_timer then
        widget_refresh_timer:stop()
        widget_refresh_timer = nil
    end

    if event_refresh_timer then
        event_refresh_timer:stop()
        event_refresh_timer = nil
    end

    if retry_timer then
        retry_timer:stop()
        retry_timer = nil
    end

    if subscription_pid then
        local pid = subscription_pid
        subscription_pid = nil
        awesome.kill(pid, 15)
    end
end

--- Remove the volume widget and stop its monitoring
local function remove_widget()
    stop_monitoring()
    awesome.emit_signal("ui::volume_widget::enabled", false)
end

--- Detect whether to use pactl or wpctl
local function get_volumectl()
    utils.find_first_executable({ "pactl", "wpctl" }, function(cmd, _)
        if cmd then
            if cmd == "wpctl" then
                volumectl = "wpctl"
                get_volume_cmd = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print int($2 * 100) }'"
                get_volume_muted_status_cmd =
                    'wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \'{ print ($3 == "[MUTED]") ? "yes" : "no" }\''
                get_micro_muted_status_cmd =
                    'wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk \'{ print ($3 == "[MUTED]") ? "yes" : "no" }\''
                get_headphones_connected_status_cmd = ""

                volume_up_cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                volume_down_cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                volume_unmute_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
                volume_mute_toggle_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                micro_mute_toggle_cmd = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

                stop_monitoring()
            end
        else
            volumectl = ""
            gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
            remove_widget()
        end
        if volume_text then
            start_monitoring()
        end
    end)
end

--- Send a volume notification
---@param value string current volume
---@param mode string increase | decrease | muted | unmuted
local function notify_volume(value, mode)
    local icon
    if mode == "increase" then
        icon = volume_up_icon
    elseif mode == "decrease" then
        icon = volume_down_icon
    elseif mode == "muted" then
        icon = volume_muted_icon
    elseif mode == "unmuted" then
        icon = volume_up_icon
    else
        gg("Unexpected mode in volume.notify_volume(): " .. tostring(mode))
        return
    end

    local notification = naughty.notify({
        text = string.format("%s Volume: %d%%", icon, value),
        timeout = 1.5,
        replaces_id = volume_notification_id,
    })
    if notification then
        volume_notification_id = notification.id
    end
end

--- Send a microphone notification
---@param mode string muted | unmuted
local function notify_micro(mode)
    local icon = mode == "muted" and microphone_muted_icon or microphone_unmuted_icon
    local notification = naughty.notify({
        text = " " .. icon .. " ",
        timeout = 1.5,
        replaces_id = volume_notification_id,
    })
    if notification then
        volume_notification_id = notification.id
    end
end

--- Get the current output volume as a percentage string
---@param callback fun(volume: string)
local function get_volume(callback)
    if volumectl == "" then
        return
    end
    utils.get_command_output(get_volume_cmd, function(out, err, _)
        if err then
            gg("Error in volume.get_volume(): " .. err)
            return
        end
        if not tonumber(out) then
            utils.log("Ignoring invalid volume output: " .. tostring(out), "warn")
            return
        end
        callback(out)
    end)
end

--- Get whether the default audio sink is muted
---@param callback fun(is_muted: boolean)
local function get_volume_muted_status(callback)
    if volumectl == "" then
        return
    end
    utils.get_command_output(get_volume_muted_status_cmd, function(status, err, _)
        if err then
            gg("Error in volume.get_volume_muted_status(): " .. err)
            return
        end
        callback(status == "yes")
    end)
end

--- Get whether the default audio source is muted
---@param callback fun(is_muted: boolean)
local function get_micro_muted_status(callback)
    if volumectl == "" then
        return
    end
    utils.get_command_output(get_micro_muted_status_cmd, function(status, err, _)
        if err then
            gg("Error in volume.get_micro_muted_status(): " .. err)
            return
        end
        callback(status == "yes")
    end)
end

--- Get whether the headphones are connected
---@param callback fun(is_connected: boolean)
local function get_headphones_connected_status(callback)
    if volumectl == "" then
        return
    end
    if volumectl == "wpctl" then
        callback(false)
        return
    end
    utils.get_command_output(get_headphones_connected_status_cmd, function(status, err, _)
        if err then
            gg("Error in volume.get_headphones_connected_status(): " .. err)
            return
        end
        callback(status == "analog-output-headphones")
    end)
end

--- Pick a volume icon from an icon array based on a volume percentage
---@param volume? number
---@return string
local function get_volicon(volume)
    if not volume then
        return volume_unmuted_icon
    end
    local count = #volume_icons
    local index = math.floor((volume / 100) * count) + 1
    if index > count then
        index = count
    end
    return volume_icons[index]
end

--- Build the text shown in the volume widget, including icon and percentage
---@param callback fun(text: string)
local function get_display_text(callback)
    get_volume(function(value)
        get_volume_muted_status(function(volume_muted)
            get_micro_muted_status(function(microphone_muted)
                get_headphones_connected_status(function(headphone_status)
                    local mic_icon = microphone_muted and " (" .. microphone_muted_icon .. ")" or ""
                    if volume_muted then
                        local vol_icon = headphone_status and headphones_muted_icon or volume_muted_icon
                        callback(string.format("%s %s%%%s", vol_icon, value, mic_icon))
                    else
                        local vol_icon = headphone_status and headphones_unmuted_icon or get_volicon(tonumber(value))
                        callback(string.format("%s %s%%%s", vol_icon, value, mic_icon))
                    end
                end)
            end)
        end)
    end)
end

--- Refresh from the selected backend, ignoring superseded responses
local function refresh_widget()
    if stopping or not volume_text then
        return
    end
    if volumectl == "" then
        remove_widget()
        return
    end

    refresh_generation = refresh_generation + 1
    local generation = refresh_generation
    get_display_text(function(text)
        if stopping or volumectl == "" then
            return
        end
        if generation == refresh_generation then
            volume_text:set_text(text)
        end
    end)
end

local function schedule_refresh()
    if event_refresh_timer and not event_refresh_timer.started then
        event_refresh_timer:start()
    end
end

local function start_subscription()
    if stopping or volumectl ~= "pactl" or subscription_pid then
        return
    end

    local pid = utils.get_command_output_lines({ "env", "LC_ALL=C", "pactl", "subscribe" }, function(line)
        if stopping or volumectl ~= "pactl" then
            return
        end
        local facility = line:match(" on ([%w%-]+) #")
        if facility == "sink" or facility == "source" or facility == "server" or facility == "card" then
            schedule_refresh()
        end
    end, {
        stderr = function(line)
            if not stopping then
                utils.log("pactl subscribe: " .. line, "warn")
            end
        end,
        exit = function(reason, code)
            subscription_pid = nil
            if not stopping and volumectl == "pactl" then
                utils.log("pactl subscribe exited: " .. reason .. " " .. tostring(code), "warn")
                if retry_timer then
                    retry_timer:again()
                end
            end
        end,
    })

    if type(pid) == "number" then
        subscription_pid = pid
        refresh_widget()
    else
        utils.log("Cannot start pactl subscribe: " .. tostring(pid), "error")
        if retry_timer then
            retry_timer:again()
        end
    end
end

start_monitoring = function()
    if stopping or not volume_text or monitoring_started then
        return
    end
    if volumectl == "" then
        remove_widget()
        return
    end
    monitoring_started = true

    if volumectl == "pactl" then
        event_refresh_timer = gears.timer({
            timeout = 0.05,
            single_shot = true,
            callback = refresh_widget,
        })
        retry_timer = gears.timer({
            timeout = 2,
            single_shot = true,
            callback = function()
                gears.timer.delayed_call(start_subscription)
            end,
        })
        start_subscription()
    else
        -- wpctl fallback: poll for changes made outside this module.
        widget_refresh_timer = gears.timer({
            timeout = poll_timeout,
            autostart = true,
            call_now = true,
            callback = refresh_widget,
        })
    end
end

awesome.connect_signal("exit", function()
    stopping = true
    stop_monitoring()
end)

--- Run a shell command asynchronously, refresh the volume widget after, and optionally invoke a callback
---@param cmd string
---@param after? fun()
local function run_and_refresh(cmd, after)
    awful.spawn.easy_async_with_shell(cmd, function()
        refresh_widget()
        if after then
            after()
        end
    end)
end

--- Create the widget; subscribe with pactl, poll with wpctl (default: 1 sec).
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    assert(volume_widget == nil, "volume.create_widget() must only be called once")

    args = args or {}
    poll_timeout = args.timeout or 1

    volume_text = wibox.widget({
        text = volume_unmuted_icon .. " --%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(
            awful.button({}, 1, function()
                M.toggle_mute(true)
            end),
            awful.button({}, 2, utils.launch("pavucontrol")),
            awful.button({}, 3, function()
                M.toggle_micro_mute()
            end),
            awful.button({}, 4, function()
                M.increase(true)
            end),
            awful.button({}, 5, function()
                M.decrease(true)
            end)
        ),
    })

    volume_widget = wibox.widget({
        {
            {
                volume_text,
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_volume or beautiful.fg_normal,
            bg = beautiful.bg_volume or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })

    start_monitoring()

    return volume_widget
end

--- Increase the output volume, refresh the widget, and show a notification
---@param disable_notification? boolean whether to disable notification after
function M.increase(disable_notification)
    if volumectl == "" then
        gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
        return
    end
    run_and_refresh(volume_unmute_cmd .. " && " .. volume_up_cmd, function()
        get_volume(function(value)
            if not disable_notification then
                notify_volume(value, "increase")
            end
        end)
    end)
end

--- Decrease the output volume, refresh the widget, and show a notification
---@param disable_notification? boolean whether to disable notification after
function M.decrease(disable_notification)
    if volumectl == "" then
        gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
        return
    end
    run_and_refresh(volume_unmute_cmd .. " && " .. volume_down_cmd, function()
        get_volume(function(value)
            if not disable_notification then
                notify_volume(value, "decrease")
            end
        end)
    end)
end

--- Toggle output mute state, refresh the widget, and show a notification
---@param disable_notification? boolean whether to disable notification after
function M.toggle_mute(disable_notification)
    if volumectl == "" then
        gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
        return
    end
    run_and_refresh(volume_mute_toggle_cmd, function()
        get_volume(function(value)
            get_volume_muted_status(function(volume_muted)
                if not disable_notification then
                    if volume_muted then
                        notify_volume(value, "muted")
                    else
                        notify_volume(value, "unmuted")
                    end
                end
            end)
        end)
    end)
end

--- Toggle microphone mute state and show a notification
function M.toggle_micro_mute()
    if volumectl == "" then
        gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
        return
    end
    run_and_refresh(micro_mute_toggle_cmd, function()
        get_micro_muted_status(function(is_muted)
            if is_muted then
                notify_micro("muted")
            else
                notify_micro("unmuted")
            end
        end)
    end)
end

get_volumectl()

return M
