local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local gears = require("gears") -- Utilities such as color parsing and objects
local wibox = require("wibox") -- Widget and layout library

local env = require("core.env")
local menu = require("ui.menu")

local M = {}

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ env.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ env.modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_tag_colors(self, tag)
    -- Decide the color based on current tag state
    if tag.selected then
        self.fg = beautiful.taglist_fg_focus
        self.bg = beautiful.taglist_bg_focus
    elseif tag.urgent then
        self.fg = beautiful.taglist_fg_urgent
        self.bg = beautiful.taglist_bg_urgent
    elseif #tag:clients() > 0 then
        self.fg = beautiful.taglist_fg_occupied
        self.bg = beautiful.taglist_bg_occupied
    else
        self.fg = beautiful.taglist_fg_empty
        self.bg = beautiful.taglist_bg_empty
    end
end

function M.setup(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id = "index_role",
                        widget = wibox.widget.textbox,
                    },
                    margins = 6,
                    widget = wibox.container.margin,
                },
                shape = gears.shape.circle,
                widget = wibox.container.background,
            },
            id = "background_role",
            widget = wibox.container.background,
            ---@diagnostic disable-next-line: unused-local
            create_callback = function(self, tag, index, objects)
                -- Update index text
                self:get_children_by_id("index_role")[1].markup = "<b> " .. tag.index .. " </b>"

                -- Set initial bg according to state
                set_tag_colors(self, tag)

                -- Configure hover behavior
                local taglist_fg_hover = beautiful.taglist_fg_hover or "#ffffff"
                local taglist_bg_hover = beautiful.taglist_bg_hover or "#535d6c"
                self:connect_signal("mouse::enter", function()
                    self._hover = true
                    self.fg = taglist_fg_hover
                    self.bg = taglist_bg_hover
                end)
                self:connect_signal("mouse::leave", function()
                    self._hover = false
                    -- Recompute based on *current* tag state
                    set_tag_colors(self, tag)
                end)
            end,
            ---@diagnostic disable-next-line: unused-local
            update_callback = function(self, tag, index, objects)
                -- Keep index in sync
                self:get_children_by_id("index_role")[1].markup = "<b> " .. tag.index .. " </b>"

                -- Tag state may have changed (selected, etc.)
                -- If we are not hovering, just update to theme color
                if not self._hover then
                    set_tag_colors(self, tag)
                end
            end,
        },
    })

    -- Create a tasklist widget (contains the names of the opened apps)
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                menu.launcher,
                wibox.widget.textclock(),
                -- s.mytasklist,
                s.mypromptbox,
                s.mylayoutbox,
            },
            nil, -- Middle widget, added below
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                awful.widget.keyboardlayout(),
                wibox.widget.systray(),
            },
        },
        { -- Middle widget (centered)
            s.mytaglist,
            halign = "center",
            valign = "center",
            layout = wibox.container.place,
        },
    })
end

return M
