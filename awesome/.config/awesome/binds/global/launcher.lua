local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

return gears.table.join(
    awful.key({ env.modkey }, "Return", function()
        awful.spawn(env.detect_terminal())
    end, { description = "open a terminal", group = "launcher" }),

    awful.key({ env.modkey }, "b", function()
        awful.spawn(env.detect_browser())
    end, { description = "open the browser", group = "launcher" }),

    awful.key({ env.modkey }, "r", env.run_launcher, { description = "run a command", group = "launcher" }),
    awful.key({ env.modkey }, "d", env.app_launcher, { description = "open apps", group = "launcher" })
)
