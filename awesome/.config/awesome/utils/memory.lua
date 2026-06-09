local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local env = require("env")

local M = {}

local prefix = "󰍛  "

local ram_text = nil
local ram_widget = nil

local function read_meminfo()
    local mem = {}
    for line in io.lines("/proc/meminfo") do
        local key, value = line:match("^(%w+):%s+(%d+)")
        if key and value then
            mem[key] = tonumber(value)
        end
    end
    return mem
end

local function refresh_widget()
    if not ram_text then
        return
    end

    local m = read_meminfo()
    if not m.MemTotal or not m.MemAvailable then
        ram_text:set_text(prefix .. "N/A")
        return
    end

    local used_kib = m.MemTotal - m.MemAvailable
    local used_gib = used_kib / 1024 / 1024
    -- local total_gib = m.MemTotal / 1024 / 1024
    local pct = math.floor((used_kib / m.MemTotal) * 100 + 0.5)

    ram_text:set_text(string.format("%s%.2f GiB (%d%%)", prefix, used_gib, pct))
end

--- Create and return the RAM widget, and start periodic refreshes (default: 1 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    ram_text = wibox.widget({
        text = prefix .. "--",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(awful.button({}, 1, env.launch_sysmon)),
    })

    ram_widget = wibox.widget({
        {
            {
                ram_text,
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_memory or beautiful.fg_normal,
            bg = beautiful.bg_memory or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })

    gears.timer({
        timeout = args.timeout or 1,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

    return ram_widget
end

return M
