local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

return gears.table.join(
    -- TODO: figure out my multiscreen situation
    awful.key({ env.altkey }, "h", function()
        awful.screen.focus_bydirection("left")
    end, { description = "focus screen to the left", group = "screen" }),
    awful.key({ env.altkey }, "l", function()
        awful.screen.focus_bydirection("right")
    end, { description = "focus screen to the right", group = "screen" }),
    awful.key({ env.altkey, "Shift" }, "h", function()
        local c = awful.client.focus.history.get(nil, 0)
        awful.client.movetoscreen(c, -1)
    end, { description = "move client to the screen on the left", group = "screen" }),
    awful.key({ env.altkey, "Shift" }, "l", function()
        local c = awful.client.focus.history.get(nil, 0)
        awful.client.movetoscreen(c, 1)
    end, { description = "move client to the screen on the right", group = "screen" })
)
