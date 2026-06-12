local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")
local utils = require("utils")

return gears.table.join(
    awful.key({ env.modkey, "Control" }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }), -- only in master (tile) layouts
    awful.key({ env.modkey, "Control" }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }), -- only in master (tile) layouts

    awful.key({ env.modkey, "Control" }, "j", function()
        awful.client.incwfact(0.05)
    end, { description = "increase client size factor", group = "layout" }), -- only in master (tile) layouts
    awful.key({ env.modkey, "Control" }, "k", function()
        awful.client.incwfact(-0.05)
    end, { description = "decrease client size factor", group = "layout" }), -- only in master (tile) layouts

    awful.key({ env.modkey, env.altkey }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }), -- only in master (tile) layouts
    awful.key({ env.modkey, env.altkey }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }), -- only in master (tile) layouts

    awful.key({ env.modkey }, "Tab", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ env.modkey, "Shift" }, "Tab", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    -- On-the-fly useless gaps change
    awful.key({ env.altkey, "Control" }, "=", function()
        utils.useless_gaps_resize(1)
    end, { description = "increase useless gaps", group = "tag" }),
    awful.key({ env.altkey, "Control" }, "-", function()
        utils.useless_gaps_resize(-1)
    end, { description = "decrease useless gaps", group = "tag" })
)
