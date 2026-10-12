--[[
System Requirements:
  - awk (gawk)
  - brightnessctl or xrandr (xorg-xrandr)
]]

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

--- Send a critical notification
---@param msg string notification text
local function gg(msg)
    utils.notify(msg, { preset = "critical", title = "Awesome Brightness Error", timeout = 5 })
end

--- Remove the brightness widget
local function remove_widget()
    if widget_refresh_timer then
        widget_refresh_timer:stop()
    end
    awesome.emit_signal("ui::brightness_widget::enabled", false)
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
        gg("Unexpected mode in brightness.notify_brightness(): " .. tostring(mode))
        return
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
    index = math.max(1, index)
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

        local value = tonumber(out)

        if not value or value ~= value or value < 0 or value > 100 then
            gg("Invalid brightnessctl reading: " .. tostring(out))
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
        remove_widget()
        return
    end

    get_display_text(function(text)
        brightness_text:set_text(text)
    end, brightness)
end

--- Run a shell command asynchronously.
--- Report failures and invoke the appropriate completion callback.
---@param cmd string shell command to execute
---@param after? fun() callback invoked on success
---@param on_error? fun(err: string) callback invoked on failure
local function run(cmd, after, on_error)
    utils.get_command_output(cmd, function(_, err)
        if err then
            gg("Could not change brightness: " .. err)

            if on_error then
                on_error(err)
            end

            return
        end

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

--- Detect whether to use brightnessctl or xrandr
local function get_brightnessctl()
    utils.find_first_executable({ "brightnessctl", "xrandr" }, function(cmd, _)
        if cmd then
            if cmd == "xrandr" then
                brightnessctl = "xrandr"

                local adjustment_busy = false
                local pending_adjustments = {}

                --- Asynchronously read a specific output's software brightness as a percentage.
                --- Invoke the callback only when a valid reading is available.
                --- Report command errors or invalid readings through the error notification helper.
                ---@param output string RandR output name, such as "eDP-1" or "HDMI-1"
                ---@param callback fun(brightness: number) callback receiving the current percentage
                ---@param on_error? fun(err: string) callback invoked when the read fails
                local function xrandr_get_brightness(output, callback, on_error)
                    local command = "LC_ALL=C xrandr --verbose | LC_ALL=C awk -v output="
                        .. utils.shell_quote(output)
                        .. [=[ '
                            /^[^[:space:]]/ {
                                selected = ($1 == output && $2 == "connected")
                            }
                            selected && /Brightness:/ {
                                print $2 * 100
                                exit
                            }
                        ']=]

                    utils.get_command_output(command, function(out, err)
                        if err then
                            gg("Could not read brightness: " .. err)

                            if on_error then
                                on_error(err)
                            end

                            return
                        end

                        local value = tonumber(out)

                        if not value or value ~= value or value < 0 or value == math.huge then
                            local message = "No valid brightness reading for " .. output
                            gg(message)

                            if on_error then
                                on_error(message)
                            end

                            return
                        end

                        callback(value)
                    end)
                end

                --- Asynchronously set an output's software brightness through xrandr
                ---@param output string RandR output name
                ---@param value number requested brightness percentage
                ---@param after? fun() callback invoked on success
                ---@param on_error? fun(err: string) callback invoked on failure
                local function xrandr_set_brightness(output, value, after, on_error)
                    local command = "xrandr --output "
                        .. utils.shell_quote(output)
                        .. " --brightness "
                        .. utils.shell_quote(tostring(value / 100))

                    run(command, after, on_error)
                end

                --- Build the brightness widget text from a percentage
                ---@param brightness string|number
                ---@return string
                function get_display_text(brightness)
                    return string.format("%s %s%%", get_bricon(tonumber(brightness)), brightness)
                end

                --- Refresh the widget using a supplied brightness or a live xrandr reading.
                --- When no value is supplied, asynchronously read the focused screen's output.
                --- Display N/A when the focused screen has no RandR output.
                ---@param brightness? string|number known brightness percentage; skips the read
                function refresh_widget(brightness)
                    if not brightness_text then
                        return
                    end

                    local function display(value)
                        brightness_text:set_text(get_display_text(value))
                    end

                    if brightness ~= nil then
                        display(brightness)
                        return
                    end

                    local s = awful.screen.focused()
                    local output = s and s.outputs and next(s.outputs)

                    if not output then
                        brightness_text:set_text(prefix .. " N/A")
                        return
                    end

                    xrandr_get_brightness(output, display)
                end

                --- Process queued adjustments one at a time.
                --- Continue with the next request after either success or failure.
                local function process_next_adjustment()
                    if adjustment_busy or #pending_adjustments == 0 then
                        return
                    end

                    local job = table.remove(pending_adjustments, 1)
                    adjustment_busy = true

                    local function finish()
                        adjustment_busy = false
                        process_next_adjustment()
                    end

                    xrandr_get_brightness(job.output, function(current)
                        local new = math.max(0, math.min(100, current + job.delta))

                        xrandr_set_brightness(job.output, new, function()
                            local value = tostring(new)
                            refresh_widget(value)
                            notify_brightness(value, job.action)
                            finish()
                        end, finish)
                    end, finish)
                end

                --- Queue a brightness adjustment for the currently focused output.
                --- Capture the output now so focus changes do not redirect a waiting request.
                ---@param delta number percentage points to add; negative values decrease brightness
                ---@param action "increase"|"decrease" notification mode
                local function adjust_brightness(delta, action)
                    local s = awful.screen.focused()
                    local output = s and s.outputs and next(s.outputs)

                    if not output then
                        gg("The focused screen has no RandR output.")
                        return
                    end

                    pending_adjustments[#pending_adjustments + 1] = {
                        output = output,
                        delta = delta,
                        action = action,
                    }

                    process_next_adjustment()
                end

                --- Increase brightness by 10
                function M.increase()
                    adjust_brightness(step, "increase")
                end

                --- Decrease brightness by 10
                function M.decrease()
                    adjust_brightness(-step, "decrease")
                end

                refresh_widget()
            end
        else
            brightnessctl = ""
            gg("Both 'brightnessctl' and 'xrandr' are not found. Your device rendering is not set up correctly.")
            remove_widget()
        end
    end)
end

--- Create and return the brightness widget
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    assert(brightness_widget == nil, "brightness.create_widget() must only be called once")

    args = args or {}

    brightness_text = wibox.widget({
        text = prefix .. " --%",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(
            awful.button({}, 4, function()
                M.increase()
            end),
            awful.button({}, 5, function()
                M.decrease()
            end)
        ),
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
