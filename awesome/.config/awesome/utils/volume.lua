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
local widget_refresh_timer = nil

local volumectl = "pactl"
local get_volume_cmd = "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | awk -F '%' '{ print $1 }'"
local get_volume_muted_status_cmd = "pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'"
local get_micro_muted_status_cmd = "pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'"
local get_headphones_connected_status_cmd = "pactl list sinks | awk -F': ' '/Active Port/ { print $2 }'"

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

--- Hide the volume widget
-- TODO: ideally I remove the widget from the layout. Try to do it with signals.
local function hide_widget()
    if widget_refresh_timer then
        widget_refresh_timer:stop()
    end
    if volume_widget then
        volume_widget.visible = false
    end
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
            end
        else
            volumectl = ""
            gg("Both 'pactl' and 'wpctl' are not found. Your device volume is not set up correctly.")
            hide_widget()
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
        gg("Unexpect mode in volume.notify_volume()")
    end

    local text = icon .. " Volume: " .. value .. "%"
    local notification = naughty.notify({
        text = text,
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

--- Refresh the volume widget text with the latest backend state
local function refresh_widget()
    if not volume_text then
        return
    end

    if volumectl == "" then
        hide_widget()
        return
    end

    get_display_text(function(text)
        volume_text:set_text(text)
    end)
end

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

--- Create and return the volume widget, and start periodic refreshes (default: 1 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    volume_text = wibox.widget({
        text = volume_unmuted_icon .. " --%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(
            -- HACK: this works for disabling notifications because for some reason awesome passes a table
            -- to these callbacks. However I have no clue what kind of table that is and what it contains.
            -- Last attempt to inspect that table resulted in a very awesome freeze.
            awful.button({}, 1, M.toggle_mute),
            awful.button({}, 2, utils.launch("pavucontrol")),
            awful.button({}, 3, M.toggle_micro_mute),
            awful.button({}, 4, M.increase),
            awful.button({}, 5, M.decrease)
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

    refresh_widget()

    -- to detect volume change when connecting headphones
    widget_refresh_timer = gears.timer({
        timeout = args.timeout or 1,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

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
