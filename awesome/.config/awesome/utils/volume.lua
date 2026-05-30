local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local volume_notification_id = nil
local volume_widget = nil

-- TODO: should I use lua instead of awk?
local get_volume_cmd = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print int($2 * 100) }'"
local get_volume_muted_status_cmd =
    'wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \'{ print ($3 == "[MUTED]") ? "yes" : "no" }\''
local get_micro_muted_status_cmd =
    'wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk \'{ print ($3 == "[MUTED]") ? "yes" : "no" }\''

local volume_up_cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
local volume_down_cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
local volume_unmute_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
local volume_mute_toggle_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
local micro_mute_toggle_cmd = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

--- Send a critical notification
---@param msg string notification text
local function gg(msg)
    utils.notify(msg, { preset = "critical", title = "Awesome Volume Error" })
end

--- Detect wether to use wpctl or pactl
local function get_volumectl()
    utils.find_first_executable({ "wpctl", "pactl" }, function(cmd, _)
        if cmd then
            if cmd == "pactl" then
                get_volume_cmd = "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | awk -F '%' '{ print $1 }'"
                get_volume_muted_status_cmd = "pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'"
                get_micro_muted_status_cmd = "pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'"

                volume_up_cmd = "pactl set-sink-volume @DEFAULT_SINK@ +5%"
                volume_down_cmd = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
                volume_unmute_cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0"
                volume_mute_toggle_cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
                micro_mute_toggle_cmd = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
            end
        else
            gg("Both 'wpctl' and 'pactl' are not found. Your device volume is not set up correctly.")
        end
    end)
end

--- Send a volume notification
---@param value string current volume
---@param mode string increase | decrease | muted | unmuted
local function notify_volume(value, mode)
    local icon
    if mode == "increase" then
        icon = ""
    elseif mode == "decrease" then
        icon = ""
    elseif mode == "muted" then
        icon = "󰖁"
    elseif mode == "unmuted" then
        icon = ""
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
    local icon = mode == "muted" and "  " or "  "
    local notification = naughty.notify({
        text = icon,
        timeout = 1.5,
        replaces_id = volume_notification_id,
    })
    if notification then
        volume_notification_id = notification.id
    end
end

--- Get the current output volume as a percentage string
---@param callback fun(out: string, err?: string, exit_code?: integer)
local function get_volume(callback)
    utils.get_command_output(get_volume_cmd, function(out, err, _)
        if err then
            gg("Error in volume.get_volume(): " .. err)
            return
        end
        callback(out)
    end)
end

--- Get whether the default audio sink is muted
---@param callback fun(status: '"yes"'|'"no"', err?: string, exit_code?: integer)
local function get_volume_muted_status(callback)
    utils.get_command_output(get_volume_muted_status_cmd, function(status, err, _)
        if err then
            gg("Error in volume.get_volume_muted_status(): " .. err)
            return
        end
        callback(status)
    end)
end

--- Get whether the default audio source is muted
---@param callback fun(status: '"yes"'|'"no"', err?: string, exit_code?: integer)
local function get_micro_muted_status(callback)
    utils.get_command_output(get_micro_muted_status_cmd, function(status, err, _)
        if err then
            gg("Error in volume.get_micro_muted_status(): " .. err)
            return
        end
        callback(status)
    end)
end

--- Build the text shown in the volume widget, including icon and percentage
---@param callback fun(text: string)
local function get_display_text(callback)
    get_volume(function(value)
        get_volume_muted_status(function(status)
            if status == "no" then
                callback(string.format("󰕾  %s%%", value))
            else
                callback(string.format("󰖁  %s%%", value))
            end
        end)
    end)
end

--- Refresh the volume widget text with the latest backend state
local function refresh_widget()
    if not volume_widget then
        return
    end

    get_display_text(function(text)
        volume_widget:set_text(text)
    end)
end

local function run_and_refresh(cmd, after)
    awful.spawn.easy_async_with_shell(cmd, function()
        refresh_widget()
        if after then
            after()
        end
    end)
end

--- Create and return the volume widget, and start periodic refreshes (default: 0.01 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    volume_widget = wibox.widget({
        text = "󰕾  --%",
        widget = wibox.widget.textbox,
    })

    refresh_widget()

    -- to detect volume change when connecting headphones
    gears.timer({
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
function M.increase()
    run_and_refresh(volume_unmute_cmd .. " && " .. volume_up_cmd, function()
        get_volume(function(value)
            notify_volume(value, "increase")
        end)
    end)
end

--- Decrease the output volume, refresh the widget, and show a notification
function M.decrease()
    run_and_refresh(volume_unmute_cmd .. " && " .. volume_down_cmd, function()
        get_volume(function(value)
            notify_volume(value, "decrease")
        end)
    end)
end

--- Toggle output mute state, refresh the widget, and show a notification
function M.toggle_mute()
    run_and_refresh(volume_mute_toggle_cmd, function()
        get_volume(function(value)
            get_volume_muted_status(function(status)
                if status == "yes" then
                    notify_volume(value, "muted")
                else
                    notify_volume(value, "unmuted")
                end
            end)
        end)
    end)
end

--- Toggle microphone mute state and show a notification
function M.toggle_micro_mute()
    run_and_refresh(micro_mute_toggle_cmd, function()
        get_micro_muted_status(function(status)
            if status == "yes" then
                notify_micro("muted")
            else
                notify_micro("unmuted")
            end
        end)
    end)
end

get_volumectl()

return M
