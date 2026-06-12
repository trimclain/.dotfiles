local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local gears = require("gears") -- Utilities such as color parsing and objects
local wibox = require("wibox") -- Widget and layout library

local env = require("env")
-- local menu = require("ui.menu")
local utils = require("utils")

local battery = require("utils.battery")
local brightness = require("utils.brightness")
local memory = require("utils.memory")
local network = require("utils.network")
local temperature = require("utils.temperature")
local volume = require("utils.volume")

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
    end)
    -- awful.button({}, 4, function(t)
    --     awful.tag.viewprev(t.screen)
    -- end),
    -- awful.button({}, 5, function(t)
    --     awful.tag.viewnext(t.screen)
    -- end)
)

-- local tasklist_buttons = gears.table.join(
--     awful.button({}, 1, function(c)
--         if c == client.focus then
--             c.minimized = true
--         else
--             c:emit_signal("request::activate", "tasklist", { raise = true })
--         end
--     end),
--     awful.button({}, 3, function()
--         awful.menu.client_list({ theme = { width = 250 } })
--     end),
--     awful.button({}, 4, function()
--         awful.client.focus.byidx(1)
--     end),
--     awful.button({}, 5, function()
--         awful.client.focus.byidx(-1)
--     end)
-- )

-- {{{ Right Widgets for Primary Screen only

local mysystray = wibox.widget({
    {
        {
            {
                base_size = 14,
                widget = wibox.widget.systray,
            },
            left = 10,
            right = 10,
            top = 6,
            bottom = 3,
            widget = wibox.container.margin,
        },
        fg = beautiful.fg_systray or beautiful.fg_normal,
        bg = beautiful.bg_widget or beautiful.bg_normal,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background,
    },
    left = 2,
    right = 2,
    top = 4,
    bottom = 4,
    widget = wibox.container.margin,
})

local myvolume = volume.create_widget()
local mybrightness = brightness.create_widget()

local mykbdlayout_inner = awful.widget.keyboardlayout()
local mykbdlayout = wibox.widget({
    {
        {
            {
                right = 10,
                widget = wibox.container.margin,
            },
            {
                text = " ", -- ⌨
                widget = wibox.widget.textbox,
            },
            {
                mykbdlayout_inner,
                left = -5,
                right = 0,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        fg = beautiful.fg_keyboard or beautiful.fg_normal,
        bg = beautiful.bg_keyboard or beautiful.bg_normal,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background,
    },
    top = 4,
    bottom = 4,
    widget = wibox.container.margin,
})
mykbdlayout:buttons(gears.table.join(
    awful.button({}, 1, function()
        mykbdlayout_inner:next_layout()
    end),
    awful.button({}, 3, function()
        utils.notify(
            "Use the Compose Key &lt;CAPS&gt;",
            { title = "Awesome Friendly Reminder", timeout = 5, preset = "low" }
        )
    end)
))

local mynetwork = network.create_widget()
local mymemory = memory.create_widget()
local mytemperature = temperature.create_widget()
local mybattery = battery.create_widget()

local mypowermenu = wibox.widget({
    {
        {
            {
                text = " 󰐥 ", -- "", "󰤆"
                widget = wibox.widget.textbox,
            },
            left = 2,
            right = 3,
            widget = wibox.container.margin,
        },
        fg = beautiful.fg_exit or beautiful.fg_normal,
        bg = beautiful.bg_widget or beautiful.bg_focus,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background,
    },
    top = 4,
    bottom = 4,
    right = 3,
    widget = wibox.container.margin,
})
mypowermenu:buttons(
    gears.table.join(
        awful.button({}, 1, utils.launch("~/.local/bin/powermenu --use-powertheme")),
        awful.button({}, 3, utils.launch("rofi -show drun"))
    )
)
-- Add on mouse hover effects (issue: tracks the enter/leave of the whole wibar)
-- mypowermenu:connect_signal("mouse::enter", function()
--     local wb = mouse.current_wibox
--     if wb then
--         -- INFO: to see all options run `find /usr/share/icons -path '*/cursors/*' | xargs -n1 basename | sort -u`
--         wb.cursor = "hand2"
--     end
-- end)
-- mypowermenu:connect_signal("mouse::leave", function()
--     local wb = mouse.current_wibox
--     if wb then
--         wb.cursor = "left_ptr"
--     end
-- end)

-- }}}

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

--- Remove a widget from its parent layout when the given signal is emitted with false
local function remove_on_signal(signal_name, parent_layout, widget)
    awesome.connect_signal(signal_name, function(enabled)
        if enabled == false then
            parent_layout:remove_widgets(widget, true)
        end
    end)
end

function M.setup(s)
    -- Create a launcher widget
    -- s.mylauncher = wibox.widget({
    --     {
    --         awful.widget.launcher({
    --             image = beautiful.awesome_icon,
    --             menu = menu.main_menu,
    --         }),
    --         forced_width = 18,
    --         forced_height = 18,
    --         strategy = "exact",
    --         widget = wibox.container.constraint,
    --     },
    --     left = 5,
    --     right = 5,
    --     top = 7,
    --     bottom = 3,
    --     widget = wibox.container.margin,
    -- })

    -- Create a textclock widget
    s.mytextclock = wibox.widget({
        {
            {
                {
                    right = 8,
                    widget = wibox.container.margin,
                },
                {
                    text = "󰥔 ", -- "󰃰 "
                    widget = wibox.widget.textbox,
                },
                {
                    wibox.widget.textclock("%a, %b %d %H:%M"),
                    right = 8,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            fg = beautiful.fg_clock or beautiful.fg_normal,
            bg = beautiful.bg_widget or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })
    s.mytextclock:buttons(gears.table.join(
        awful.button({}, 1, function()
            if not s.mycalendar_month then
                s.mycalendar_month = awful.widget.calendar_popup.month({
                    screen = s,
                    position = "tl", -- top left
                    -- margin = 8,
                })
            end
            s.mycalendar_month:toggle()
        end),
        awful.button({}, 3, function()
            if not s.mycalendar_year then
                s.mycalendar_year = awful.widget.calendar_popup.year({
                    screen = s,
                    position = "tl", -- top left
                    -- margin = 8,
                })
            end
            s.mycalendar_year:toggle()
        end)
    ))

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = wibox.widget({
        {
            {
                {
                    {
                        {
                            awful.widget.layoutbox(s),
                            left = 2,
                            right = 2,
                            top = 3,
                            widget = wibox.container.margin,
                        },
                        forced_width = 18,
                        forced_height = 18,
                        strategy = "exact",
                        widget = wibox.container.constraint,
                    },
                    valign = "center",
                    halign = "center",
                    widget = wibox.container.place,
                },
                left = 6,
                right = 6,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_layoutbox or beautiful.fg_normal,
            bg = beautiful.bg_widget or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })
    -- stylua: ignore
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    -- Create a promptbox for each screen (used for awful.prompt.run and in case we use the awesome menubar)
    s.mypromptbox = awful.widget.prompt()

    -- -- Create a tasklist widget (contains the names of the opened apps)
    -- s.mytasklist = awful.widget.tasklist({
    --     screen = s,
    --     filter = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons,
    -- })

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
                    margins = 8,
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
                self:get_children_by_id("index_role")[1].markup = "<b>" .. tag.name .. "</b>"

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
                self:get_children_by_id("index_role")[1].markup = "<b>" .. tag.name .. "</b>"

                -- Tag state may have changed (selected, etc.)
                -- If we are not hovering, just update to theme color
                if not self._hover then
                    set_tag_colors(self, tag)
                end
            end,
        },
    })

    local left_widgets = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 5,
        -- s.mylauncher,
        s.mytextclock,
        s.mylayoutbox,
        s.mypromptbox,
        -- s.mytasklist,
    }

    local right_widgets = wibox.layout.fixed.horizontal()
    right_widgets.spacing = 5

    -- primary monitor only widgets
    if s == screen.primary then
        right_widgets:add(mysystray)
        right_widgets:add(myvolume)
        right_widgets:add(mybrightness)
        right_widgets:add(mykbdlayout)
        right_widgets:add(mynetwork)
        right_widgets:add(mymemory)
        right_widgets:add(mytemperature)
        right_widgets:add(mybattery)
        right_widgets:add(mypowermenu)

        remove_on_signal("ui::volume_widget::enabled", right_widgets, myvolume)
        remove_on_signal("ui::brightness_widget::enabled", right_widgets, mybrightness)
    end

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })
    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            left_widgets,
            nil, -- Middle widget, added below
            right_widgets,
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
