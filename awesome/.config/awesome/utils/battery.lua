--[[
System Requirements:
  - ls (coreutils)
]]

local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local prefix = "󰁹 "
local poll_timeout = 1

local battery_text = nil
local battery_widget = nil
local battery_path = nil
local batteries = {}

-- { "", "", "", "", "" }
-- { "󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" }
local function get_prefix(status, pct)
    if status == "Charging" then
        return "󰂄 "
    elseif status == "Full" or pct >= 95 then
        return "󰁹 "
    elseif pct <= 10 then
        return "󰂎 "
    elseif pct <= 20 then
        return "󰁺 "
    elseif pct <= 30 then
        return "󰁻 "
    elseif pct <= 40 then
        return "󰁼 "
    elseif pct <= 50 then
        return "󰁽 "
    elseif pct <= 60 then
        return "󰁾 "
    elseif pct <= 70 then
        return "󰁿 "
    elseif pct <= 80 then
        return "󰂀 "
    elseif pct <= 90 then
        return "󰂁 "
    else
        return "󰂂 "
    end
end

local function refresh_widget()
    if not battery_text then
        return
    end

    if #batteries == 0 then
        battery_text:set_text(prefix .. "N/A")
        return
    end

    -- only display the first discovered battery
    battery_path = batteries[1]

    if utils.readline(battery_path .. "/present") == "0" then
        battery_text:set_text(prefix .. "N/A")
        return
    end

    local capacity = tonumber(utils.readline(battery_path .. "/capacity"))
    if not capacity or capacity < 0 or capacity > 100 or capacity % 1 ~= 0 then
        battery_text:set_text(prefix .. "N/A")
        return
    end

    local status = utils.readline(battery_path .. "/status")

    battery_text:set_text(string.format("%s%d%%", get_prefix(status, capacity), capacity))
end

--- Discover battery supplies and refresh when enumeration completes.
local function discover_batteries()
    local pspath = "/sys/class/power_supply/"

    utils.get_command_output("ls -1 " .. utils.shell_quote(pspath), function(out, err)
        if err then
            utils.log("Battery discovery failed: " .. err, "warn")
            refresh_widget()
            return
        end

        for _, name in ipairs(utils.split(out, "\n")) do
            local base = pspath .. name
            if utils.readline(base .. "/type") == "Battery" then
                batteries[#batteries + 1] = base
            end
        end

        refresh_widget()
    end)
end

--- Create and return the battery widget, and start periodic refreshes (default: 1 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    assert(battery_widget == nil, "battery.create_widget() must only be called once")

    args = args or {}
    poll_timeout = args.timeout or 1

    battery_text = wibox.widget({
        text = prefix .. "--",
        widget = wibox.widget.textbox,
    })

    battery_widget = wibox.widget({
        {
            {
                battery_text,
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_battery or beautiful.fg_normal,
            bg = beautiful.bg_battery or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })

    discover_batteries()

    gears.timer({
        timeout = poll_timeout,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

    return battery_widget
end

return M
