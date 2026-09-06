local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

return gears.table.join(
    -- By-direction client focus
    awful.key({ env.modkey }, "j", function()
        awful.client.focus.global_bydirection("down")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus down", group = "client" }),
    awful.key({ env.modkey }, "k", function()
        awful.client.focus.global_bydirection("up")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus up", group = "client" }),
    awful.key({ env.modkey }, "h", function()
        awful.client.focus.global_bydirection("left")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus left", group = "client" }),
    awful.key({ env.modkey }, "l", function()
        awful.client.focus.global_bydirection("right")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus right", group = "client" }),

    -- By-direction client swap
    awful.key({ env.modkey, "Shift" }, "j", function()
        awful.client.swap.global_bydirection("down")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with down client", group = "client" }),
    awful.key({ env.modkey, "Shift" }, "k", function()
        awful.client.swap.global_bydirection("up")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with up client", group = "client" }),
    awful.key({ env.modkey, "Shift" }, "h", function()
        awful.client.swap.global_bydirection("left")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with left client", group = "client" }),
    awful.key({ env.modkey, "Shift" }, "l", function()
        awful.client.swap.global_bydirection("right")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with right client", group = "client" }),

    -- Focus floating clients when they are unfocused and hidden behind normal clients
    awful.key({ env.modkey }, "n", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next client", group = "client" }),

    -- Fix osu awful behavior when you switch tags from the fullscreen game
    awful.key({ env.modkey, "Shift" }, "m", function()
        for _, c in ipairs(client.get()) do
            if c.minimized then
                c.minimized = false
                c:emit_signal("request::activate", "key.unminimize", { raise = true })
                return
            end
        end
    end, { description = "unminimize next client", group = "client" })
)
