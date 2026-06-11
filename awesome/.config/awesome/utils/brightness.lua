local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local prefix = "󰃝"
local brightness_up_icon = "🔆"
local brightness_down_icon = "🔅"
local brightness_icons = { "", "", "", "", "", "", "", "", "" }

local brightness_notification_id = nil
local brightness_text = nil
local brightness_widget = nil
local widget_refresh_timer = nil

local step = 10
local brightnessctl = "brightnessctl"
local current_brightness_file = "/tmp/current_brightness" -- used only with xrandr

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

--- Send a brightness notification
---@param value string current brightness
---@param mode string either `"increase"` or `"decrease"`
local function notify_brightness(value, mode)
    local icon
    if mode == "increase" then
        icon = brightness_up_icon
    elseif mode == "decrease" then
        icon = brightness_down_icon
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

--- Pick a brightness icon from an icon array based on a brightness percentage
---@param brightness? number
---@return string
local function get_bricon(brightness)
    if not brightness then
        return prefix
    end
    local count = #brightness_icons
    local index = math.floor((brightness / 100) * count) + 1
    if index > count then
        index = count
    end
    return brightness_icons[index]
end

--- Get the current output brightness as a percentage string and pass it to the provided callback function
---@param callback fun(brightness: string)
local function get_brightness(callback)
    if brightnessctl == "" then
        return
    end

    utils.get_command_output("brightnessctl g -P", function(out, err, _)
        if err then
            gg("Error in brightness.get_brightness(): " .. err)
            return
        end
        callback(out)
    end)
end

--- Build the text shown in the brightness widget, including icon and percentage
---@param callback fun(text: string)
---@param brightness? string the brightness to use in case we already have the latest state
local function get_display_text(callback, brightness)
    if brightness then
        callback(string.format("%s %s%%", get_bricon(tonumber(brightness)), brightness))
    else
        get_brightness(function(value)
            callback(string.format("%s %s%%", get_bricon(tonumber(value)), value))
        end)
    end
end

--- Refresh the brightness widget text with the latest backend state
---@param brightness? string the brightness to use in case we already have the latest state
local function refresh_widget(brightness)
    if not brightness_text then
        return
    end

    if brightnessctl == "" then
        hide_widget()
        return
    end

    get_display_text(function(text)
        brightness_text:set_text(text)
    end, brightness)
end

--- Run a shell command asynchronously and optionally invoke a callback
---@param cmd string
---@param after? fun()
local function run(cmd, after)
    awful.spawn.easy_async_with_shell(cmd, function()
        if after then
            after()
        end
    end)
end

--- Refresh the brightness widget and show a brightness notification after retrieving the current brightness value
---@param mode string either `"increase"` or `"decrease"`
local function do_after(mode)
    get_brightness(function(value)
        refresh_widget(value)
        notify_brightness(value, mode)
    end)
end

--- Increase the output brightness, refresh the widget, and show a notification
function M.increase()
    if brightnessctl == "" then
        gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
        return
    end
    run("brightnessctl s +" .. step .. "% -q", function()
        do_after("increase")
    end)
end

--- Decrease the output brightness, refresh the widget, and show a notification
function M.decrease()
    if brightnessctl == "" then
        gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
        return
    end

    run("brightnessctl s " .. step .. "%- -q", function()
        do_after("decrease")
    end)
end

--- Detect whether to use wpctl or pactl
local function get_brightnessctl()
    utils.find_first_executable({ "brightnessctl", "xrandr" }, function(cmd, _)
        if cmd then
            if cmd == "xrandr" then
                brightnessctl = "xrandr"

                --- Get the current brightness as a percentage string and pass it to the provided function
                ---@param callback fun(brightness: string)
                local function xrandr_get_brightness(callback)
                    local command = "xrandr --verbose | awk '/Brightness/ { print $2 * 100; exit }'"
                    utils.get_command_output(command, function(out, err, _)
                        if err then
                            gg("Error in brightness.xrandr_get_brightness(): " .. err)
                            return
                        end
                        callback(out)
                    end)
                end

                -- make sure current_brightness_file exists with the updated informatio
                xrandr_get_brightness(function(brightness)
                    utils.write_file(current_brightness_file, brightness)
                end)

                --- Set current brightness using xrandr
                ---@param value number current brightness in percent
                local function xrandr_set_brightness(value)
                    local s = awful.screen.focused()
                    local monitor_name = next(s.outputs) -- e.g. HDMI-0
                    local command = "xrandr --output " .. monitor_name .. " --brightness " .. value / 100
                    awful.spawn(command)
                end

                --- Build the text shown in the brightness widget, including icon and percentage
                ---@param brightness string
                ---@return string
                function get_display_text(brightness)
                    return string.format("%s %s%%", get_bricon(tonumber(brightness)), brightness)
                end

                --- Refresh the brightness widget text with the latest backend state
                ---@param brightness? string the brightness to use in case we already have the latest state
                function refresh_widget(brightness)
                    if not brightness_text then
                        return
                    end

                    if not brightness then
                        brightness = utils.readline(current_brightness_file) or "N/A"
                    end

                    brightness_text:set_text(get_display_text(brightness))
                end

                --- Adjust brightness by a delta, then persist, refresh, and notify
                ---@param delta number amount to add to the current brightness; negative values decrease it
                ---@param action string either `"increase"` or `"decrease"`
                local function adjust_brightness(delta, action)
                    local current = tonumber(utils.readline(current_brightness_file))
                    if not current then
                        xrandr_get_brightness(function(brightness)
                            utils.write_file(current_brightness_file, brightness)
                            current = tonumber(brightness)
                        end)
                    end

                    local new = math.max(0, math.min(100, current + delta))
                    xrandr_set_brightness(new)

                    local new_str = tostring(new)
                    utils.write_file(current_brightness_file, new_str)
                    refresh_widget(new_str)
                    notify_brightness(new_str, action)
                end

                --- Increase brightness by 10
                function M.increase()
                    adjust_brightness(step, "increase")
                end

                --- Decrease brightness by 10
                function M.decrease()
                    adjust_brightness(-step, "decrease")
                end
            end
        else
            brightnessctl = ""
            gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
            hide_widget()
        end
    end)
end

--- Create and return the brightness widget
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    brightness_text = wibox.widget({
        text = prefix .. " --%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(awful.button({}, 4, M.increase), awful.button({}, 5, M.decrease)),
    })

    brightness_widget = wibox.widget({
        {
            {
                brightness_text,
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_brightness or beautiful.fg_normal,
            bg = beautiful.bg_brightness or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
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

get_brightnessctl()

return M
