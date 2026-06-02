local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local gears = require("gears") -- Utilities such as color parsing and objects
local wibox = require("wibox") -- Widget and layout library

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Make corners round
    c.shape = function(cr, w, h)
        local radius = 7 -- default: 10
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-- Automatically jump to urgent clients
client.connect_signal("property::urgent", function(c)
    if c.urgent then
        c:jump_to()
        client.focus = c
        c:raise()
    end
end)

-- -- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", { raise = false })
-- end)

-- Update border colors
client.connect_signal("focus", function(c)
    if c.floating then
        c.border_color = beautiful.border_floating or beautiful.border_focus
    else
        c.border_color = beautiful.border_focus
    end
end)
client.connect_signal("unfocus", function(c)
    if c.floating then
        c.border_color = beautiful.border_floating or beautiful.border_normal
    else
        c.border_color = beautiful.border_normal
    end
end)
client.connect_signal("property::floating", function(c)
    if c.floating then
        c.border_color = beautiful.border_floating or beautiful.border_focus
    elseif c == client.focus then
        c.border_color = beautiful.border_focus
    else
        c.border_color = beautiful.border_normal
    end
end)
