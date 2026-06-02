local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local brightness_notification_id = nil
local brightness_widget = nil
local widget_refresh_timer = nil

local brightnessctl = "brightnessctl"
local get_brightness_cmd = "brightnessctl g -P"
local brightness_up_cmd = "brightnessctl s +10% -q"
local brightness_down_cmd = "brightnessctl s 10%- -q"

--- Send a critical notification
---@param msg string notification text
local function gg(msg)
    utils.notify(msg, { preset = "critical", title = "Awesome Brightness Error", timeout = 5 })
end

--- Hide the brightness widget
local function hide_widget()
    if widget_refresh_timer then
        widget_refresh_timer:stop()
    end
    if brightness_widget then
        brightness_widget.visible = false
    end
end

--- Detect whether to use wpctl or pactl
local function get_brightnessctl()
    utils.find_first_executable({ "brightnessctl", "xrandr" }, function(cmd, _)
        if cmd then
            if cmd == "xrandr" then
                -- TODO: should I use lua instead of awk?
                -- TODO: implement writing to a file on increase, since the read will cost too much like this
                brightnessctl = ""
                hide_widget()
                get_brightness_cmd = "xrandr --verbose | awk '/Brightness/ { print $2 * 100; exit }'"
                brightness_up_cmd =
                    "xrandr --output \"$(xrandr | awk '/ primary / {print $1; exit}')\" --brightness \"$(xrandr --verbose | awk '/Brightness/ {v=$2+0.1; if (v>1) v=1; print v; exit}')\""
                brightness_down_cmd =
                    "xrandr --output \"$(xrandr | awk '/ primary / {print $1; exit}')\" --brightness \"$(xrandr --verbose | awk '/Brightness/ {v=$2-0.1; if (v<0) v=0; print v; exit}')\""
            end
        else
            brightnessctl = ""
            gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
            hide_widget()
        end
    end)
end

--- Send a brightness notification
---@param value string current brightness
---@param mode string increase | decrease
local function notify_brightness(value, mode)
    local icon
    if mode == "increase" then
        icon = "🔆"
    elseif mode == "decrease" then
        icon = "🔅"
    else
        gg("Unexpect mode in brightness.notify_brightness()")
    end

    local text = icon .. " Brightness: " .. value .. "%"
    local notification = naughty.notify({
        text = text,
        timeout = 1.5,
        replaces_id = brightness_notification_id,
    })
    if notification then
        brightness_notification_id = notification.id
    end
end

--- Get the current output brightness as a percentage string
---@param callback fun(out: string, err?: string, exit_code?: integer)
local function get_brightness(callback)
    if brightnessctl == "" then
        return
    end
    utils.get_command_output(get_brightness_cmd, function(out, err, _)
        if err then
            gg("Error in brightness.get_brightness(): " .. err)
            return
        end
        callback(out)
    end)
end

--- Build the text shown in the brightness widget, including icon and percentage
---@param callback fun(text: string)
local function get_display_text(callback)
    get_brightness(function(value)
        callback(string.format("󰃝  %s%%", value))
    end)
end

--- Refresh the brightness widget text with the latest backend state
local function refresh_widget()
    if not brightness_widget then
        return
    end

    if brightnessctl == "" then
        hide_widget()
        return
    end

    get_display_text(function(text)
        brightness_widget:set_text(text)
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

--- Create and return the brightness widget, and start periodic refreshes (default: 0.01 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    brightness_widget = wibox.widget({
        text = "󰃝  --%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(awful.button({}, 4, M.increase), awful.button({}, 5, M.decrease)),
    })

    refresh_widget()

    -- widget_refresh_timer = gears.timer({
    --     timeout = args.timeout or 10,
    --     autostart = true,
    --     call_now = true,
    --     callback = function()
    --         refresh_widget()
    --     end,
    -- })

    return brightness_widget
end

--- Increase the output brightness, refresh the widget, and show a notification
function M.increase()
    if brightnessctl == "" then
        gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
        return
    end
    run_and_refresh(brightness_up_cmd, function()
        get_brightness(function(value)
            notify_brightness(value, "increase")
        end)
    end)
end

--- Decrease the output brightness, refresh the widget, and show a notification
function M.decrease()
    if brightnessctl == "" then
        gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
        return
    end
    run_and_refresh(brightness_down_cmd, function()
        get_brightness(function(value)
            notify_brightness(value, "decrease")
        end)
    end)
end

get_brightnessctl()

return M
