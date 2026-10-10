local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local env = require("env")

local M = {}

local prefix = "󰍛 "
local poll_timeout = 1

local ram_text = nil
local ram_widget = nil

local compact = false

local function read_meminfo()
    local file = io.open("/proc/meminfo", "r")
    if not file then
        return nil
    end

    local mem = {}

    for line in file:lines() do
        local key, value = line:match("^(%w+):%s+(%d+)")
        if key and value then
            mem[key] = tonumber(value)
        end
    end

    file:close()
    return mem
end

local function refresh_widget()
    if not ram_text then
        return
    end

    local m = read_meminfo()
    if not m or not m.MemTotal or m.MemTotal <= 0 or not m.MemAvailable then
        ram_text:set_text(prefix .. "N/A")
        return
    end

    -- estimate used RAM from memory available without swapping
    local used_kib = m.MemTotal - m.MemAvailable
    local used_gib = used_kib / 1024 / 1024
    -- local total_gib = m.MemTotal / 1024 / 1024
    local pct = math.floor((used_kib / m.MemTotal) * 100 + 0.5)

    local pct_str = compact and "" or string.format(" (%d%%)", pct)

    ram_text:set_text(string.format("%s%.2f GiB", prefix, used_gib) .. pct_str)
end

--- Create and return the RAM widget, and start periodic refreshes (default: 1 sec)
---@param args? { timeout?: integer, compact?: boolean }
---@return any
function M.create_widget(args)
    assert(ram_widget == nil, "memory.create_widget() must only be called once")

    args = args or {}
    poll_timeout = args.timeout or 1

    compact = args.compact == true

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
        timeout = poll_timeout,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

    return ram_widget
end

return M
