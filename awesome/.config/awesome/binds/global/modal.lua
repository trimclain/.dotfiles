local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

local modalbind = require("modalbind")

local utils = require("utils")

modalbind.init()

modalbind.set_location("centered") -- options: top_left, top_right, bottom_left, bottom_right, left, right, top, bottom, centered, center_vertical, center_horizontal
modalbind.set_x_offset(10) -- move the wibox the given amount of pixels to the right
modalbind.set_y_offset(-10) -- move the wibox the given amount of pixels to the bottom
modalbind.set_opacity(0.95) -- change the opacity of the box with float between 0.0 and 1.0
modalbind.hide_default_options() -- hide that esc or return exits the box

-- local brightness_mode = {
--     name = "Brightness Control",
--     stay_in_mode = false,
--     layout = 0,
--     keymap = {
--         { "0", utils.launch("~/.local/bin/brightness-control --zero"), "0%" },
--         { "5", utils.launch("~/.local/bin/brightness-control --half"), "50%" },
--         { "1", utils.launch("~/.local/bin/brightness-control --full"), "100%" },
--     },
-- }

local monitor_mode = {
    name = "Monitor Layout",
    stay_in_mode = false,
    layout = 0,
    keymap = {
        { "1", utils.launch("~/.local/bin/monitor-layout --first"), "First" },
        { "2", utils.launch("~/.local/bin/monitor-layout --second"), "Second" },
        { "e", utils.launch("~/.local/bin/monitor-layout --extend"), "Dual" },
        { "d", utils.launch("~/.local/bin/monitor-layout --duplicate"), "Duplicate" },
    },
}

return gears.table.join(
    -- awful.key({ env.altkey }, "b", function()
    --     modalbind.grab(brightness_mode)
    -- end, { description = "enter brightness mode", group = "modes" }),
    awful.key({ env.altkey }, "m", function()
        modalbind.grab(monitor_mode)
    end, { description = "enter monitor mode", group = "modes" })
)
