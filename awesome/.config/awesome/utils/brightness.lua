local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local prefix = "󰃝  "

local brightness_notification_id = nil
local brightness_text = nil
local brightness_widget = nil
local widget_refresh_timer = nil

local brightnessctl = "brightnessctl"
local current_brightness_file = "/tmp/current_brightness" -- used only with xrandr
local get_brightness_cmd = "brightnessctl g -P"
local get_brightness_cmd_slow = "brightnessctl g -P" -- useful only with xrandr
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
                brightnessctl = "xrandr"

                get_brightness_cmd = "cat " .. current_brightness_file
                -- TODO: should I use lua instead of awk?
                get_brightness_cmd_slow = "xrandr --verbose | awk '/Brightness/ { print $2 * 100; exit }'"
                utils.get_command_output(get_brightness_cmd_slow, function(out, err, _)
                    if err then
                        gg("Error in brightness.get_brightnessctl(): " .. err)
                        return
                    end
                    utils.write_file(current_brightness_file, out)
                end)

                -- TODO: get the name of current monitor (e.g. HDMI-0) to pass to xrandr
                -- local s = mouse.screen -- screen under mouse
                -- local s = awful.screen.focused() -- screen foucsed by awesome
                -- local output_name = next(s.outputs)
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
---@param slow? boolean wheter to use xrandr or cat (useful when using xrandr to control brightness)
local function get_brightness(callback, slow)
    if brightnessctl == "" then
        return
    end
    local cmd = slow and get_brightness_cmd_slow or get_brightness_cmd
    utils.get_command_output(cmd, function(out, err, _)
        if err then
            gg("Error in brightness.get_brightness(): " .. err)
            return
        end
        callback(out)
    end)
end

--- Build the text shown in the brightness widget, including icon and percentage
---@param callback fun(text: string)
---@param text? string the text to use in case we already have the latest state
local function get_display_text(callback, text)
    if text then
        callback(string.format("%s%s%%", prefix, text))
    else
        get_brightness(function(value)
            callback(string.format("%s%s%%", prefix, value))
        end)
    end
end

--- Refresh the brightness widget text with the latest backend state
---@param value? string the text to set the widget to in case we already have the latest state
local function refresh_widget(value)
    if not brightness_text then
        return
    end

    if brightnessctl == "" then
        hide_widget()
        return
    end

    get_display_text(function(text)
        brightness_text:set_text(text)
    end, value)
end

--- Run cmd asynchronously and optionally execute a function after
local function run(cmd, after)
    awful.spawn.easy_async_with_shell(cmd, function()
        if after then
            after()
        end
    end)
end

---@param mode string increase | decrease
local function do_after(mode)
    get_brightness(function(value)
        if brightnessctl == "xrandr" then
            utils.write_file(current_brightness_file, value)
        end
        refresh_widget(value)
        notify_brightness(value, mode)
    end, true)
end

--- Create and return the brightness widget
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    brightness_text = wibox.widget({
        text = prefix .. "--%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(awful.button({}, 4, M.increase), awful.button({}, 5, M.decrease)),
    })

    brightness_widget = wibox.widget({
        {
            brightness_text,
            -- left = 6,
            -- right = 6,
            -- top = 2,
            -- bottom = 2,
            widget = wibox.container.margin,
        },
        fg = beautiful.fg_brightness or beautiful.fg_normal,
        bg = beautiful.bg_brightness or beautiful.bg_normal,
        widget = wibox.container.background,
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
    run(brightness_up_cmd, function()
        do_after("increase")
    end)
end

--- Decrease the output brightness, refresh the widget, and show a notification
function M.decrease()
    if brightnessctl == "" then
        gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
        return
    end
    run(brightness_down_cmd, function()
        do_after("decrease")
    end)
end

get_brightnessctl()

return M
