local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local env = require("env")
local utils = require("utils")

local M = {}

local temp_text = nil
local temp_widget = nil

-- this usually symlinks to /sys/devices/virtual/thermal/thermal_zone0/temp
local temp_path = "/sys/class/thermal/thermal_zone0/temp"
local threshold = 90

local function refresh_widget()
    if not temp_text then
        return
    end

    local line = utils.read_first_line(temp_path)

    if not line then
        temp_text:set_text(" N/A")
        return
    end

    local millidegrees_c = tonumber(line)
    if not millidegrees_c then
        temp_text:set_text(" NaN")
        return
    end

    local degrees_c = math.floor(millidegrees_c / 1000 + 0.5)

    if degrees_c >= threshold then
        local hot_fg = beautiful.bg_urgent or "#ff0000"
        temp_text:set_markup(string.format('<span foreground="%s"> %d°C</span>', hot_fg, degrees_c))
    else
        temp_text:set_text(string.format(" %d°C", degrees_c))
    end
end

--- Create and return the temperature widget, and start periodic refreshes (default: 2 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    temp_text = wibox.widget({
        text = " --",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(awful.button({}, 1, env.launch_sysmon)),
    })

    temp_widget = wibox.widget({
        {
            temp_text,
            -- left = 6,
            -- right = 6,
            -- top = 2,
            -- bottom = 2,
            widget = wibox.container.margin,
        },
        fg = beautiful.fg_temperature or beautiful.fg_normal,
        bg = beautiful.bg_temperature or beautiful.bg_normal,
        widget = wibox.container.background,
    })

    gears.timer({
        timeout = args.timeout or 2,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

    return temp_widget
end

return M
