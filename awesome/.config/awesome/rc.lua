-- vim:fileencoding=utf-8:foldmethod=marker

--#############################################################################
--        ______ ___    __ __   ___    ____  __     __     __  __   __
--       /_  __//   \  / //  \ /   |  / __/ / /    /  |   / / /  \ / /
--        / /  /   _/ / // /\\/ /| | / /   / /    /   |  / / / /\\/ /
--       / /  / /\ \ / // / \/_/ | |/ /__ / /___ / _  | / / / / \/ /
--      /_/  /_/ \_\/_//_/       |_|\___//_____//_/ \_|/_/ /_/  /_/
--
--
--       Arthur McLain (trimclain)
--       mclain.it@gmail.com
--       https://github.com/trimclain
--
--#############################################################################

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- {{{ Required libraries
-- ############################################################################

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears") -- Utilities such as color parsing and objects
local awful = require("awful") -- Everything related to window managment
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library
naughty.config.defaults["icon_size"] = 100 -- otherwise the notification popup is too big
--local menubar       = require("menubar") -- I use rofi

local lain = require("lain")
local freedesktop = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility
-- }}}

-- {{{ Modalbind Config
-- ############################################################################
-- This module helps to add i3-like keybinding modes
local modalbind = require("modalbind")
modalbind.init()

modalbind.default_keys = {
    { "separator", "Mode Control:" },
    { "Escape", modalbind.close_box, "Close Modal" },
    { "Return", modalbind.close_box, "Close Modal" },
    { "separator", "Keybindings:" },
}
modalbind.set_location("bottom_left") -- options: top_left, top_right, bottom_left, bottom_right, left, right, top, bottom, centered, center_vertical, center_horizontal
modalbind.set_x_offset(10) -- move the wibox the given amount of pixels to the right
modalbind.set_y_offset(-10) -- move the wibox the given amount of pixels to the bottom
modalbind.set_opacity(0.95) -- change the opacity of the box with float between 0.0 and 1.0
modalbind.hide_default_options() -- hide that esc or return exits the box
-- }}}

-- {{{ Some Extra Configs
-- ############################################################################
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
-- local debian = require("debian.menu")
-- }}}

-- {{{ Error handling
-- ############################################################################

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
-- ############################################################################

-- This function will run once every time Awesome is started
-- local function run_once(cmd_arr)
--     for _, cmd in ipairs(cmd_arr) do
--         awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
--     end
-- end
--
-- unclutter removes idle cursor image from screen
-- run_once({ "kitty", "unclutter -root" }) -- comma-separated entries

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]
-- }}}

-- {{{ Variable definitions
-- ############################################################################

local themes = {
    "blackburn", -- 1
    "copland", -- 2
    "dremora", -- 3
    "holo", -- 4
    "multicolor", -- 5
    "powerarrow", -- 6
    "powerarrow-dark", -- 7
    "rainbow", -- 8
    "steamburn", -- 9
    "vertex", -- 10
    "powerarrow-custom", -- 11
    "powerarrow-blue", -- 12
    "gtk", -- 13
}

-- choose your theme here
local chosen_theme = themes[11]
local modkey = "Mod1" -- default: Mod4 (windows key)
local altkey = "Mod4" -- default: Mod1 (alt key)
local terminal = "kitty"
local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev = true -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor = os.getenv("EDITOR") or "nvim"
local browser = "brave-browser"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6" }
-- awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

awful.util.taglist_buttons = mytable.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
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

awful.util.tasklist_buttons = mytable.join(
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

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- {{{ Menu
-- ############################################################################
-- Create a launcher widget and a main menu
local myawesomemenu = {
    {
        "Hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "Manual", string.format("%s -e man awesome", terminal) },
    { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "Restart", awesome.restart },
    {
        "Quit",
        function()
            awesome.quit()
        end,
    },
}

local menu_awesome = { "Awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "Open Terminal", terminal }
local menu_logout = {
    "Logout",
    function()
        awesome.quit()
    end,
}
local menu_sleep = { "Sleep", "systemctl suspend" }
local menu_restart = { "Restart", "systemctl reboot" }
local menu_shutdown = { "Shutdown", "systemctl poweroff" }

awful.util.mymainmenu = freedesktop.menu.build({
    before = {
        menu_awesome,
        -- other triads can be put here
    },
    after = {
        menu_terminal,
        menu_logout,
        menu_sleep,
        menu_restart,
        menu_shutdown,
        -- other triads can be put here
    },
})

-- Hide the menu when the mouse leaves it
--[[
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)
--]]

-- Set the Menubar terminal for applications that require it
--menubar.utils.terminal = terminal
-- }}}

-- {{{ Screen
-- ############################################################################

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
end)
-- }}}

-- {{{ Mouse bindings
-- ############################################################################
-- 1 is leftclick, 2 is middleclick, 3 is rightclick, 4 is wheel up, 5 is wheel down

root.buttons(mytable.join(
    awful.button({}, 3, function()
        awful.util.mymainmenu:toggle()
    end)
    -- I don't want the Scrolling Wheel to move me to next tag
    -- awful.button({}, 4, awful.tag.viewnext),
    -- awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Local Functions
local spawn_terminal_command = function(cmd, opts)
    local runcmd
    if opts then
        runcmd = cmd .. " " .. opts
    else
        runcmd = cmd
    end
    local runpromt = "if command -v "
        .. cmd
        .. " > /dev/null; then "
        .. runcmd
        .. "; else notify-send 'Error: "
        .. cmd
        .. " not found'; fi"
    awful.spawn.with_shell(runpromt)
end
-- }}}

-- {{{ Keybinding Modes
-- ############################################################################
-- System Mode
local sysmap = {
    {
        "e",
        function()
            awesome.quit()
        end,
        "Logout",
    },
    {
        "s",
        function()
            awful.spawn.with_shell("systemctl suspend")
        end,
        "Suspend",
    },
    {
        "r",
        function()
            awful.spawn.with_shell("systemctl reboot")
        end,
        "Restart",
    },
    {
        "S",
        function()
            awful.spawn.with_shell("systemctl poweroff")
        end,
        "Shutdown",
    },
}

-- Brightness Mode
local brightmap = {
    {
        "0",
        function()
            spawn_terminal_command("$HOME/.local/bin/display-brightness", "--zero")
        end,
        "0%",
    },
    {
        "5",
        function()
            spawn_terminal_command("$HOME/.local/bin/display-brightness", "--half")
        end,
        "50%",
    },
    {
        "1",
        function()
            spawn_terminal_command("$HOME/.local/bin/display-brightness", "--full")
        end,
        "100%",
    },
}

-- Keyboard Layout Mode
local layoutmap = {
    {
        "1",
        function()
            spawn_terminal_command("$HOME/.local/bin/keyboard-layout", "--no-german")
        end,
        "us, ru",
    },
    {
        "2",
        function()
            spawn_terminal_command("$HOME/.local/bin/keyboard-layout", "--german")
        end,
        "us, de, ru",
    },
}

-- Monitor Mode
local monimap = {
    {
        "1",
        function()
            spawn_terminal_command("$HOME/.local/bin/monitor-layout", "--first")
        end,
        "First",
    },
    {
        "2",
        function()
            spawn_terminal_command("$HOME/.local/bin/monitor-layout", "--second")
        end,
        "Second",
    },
    {
        "d",
        function()
            spawn_terminal_command("$HOME/.local/bin/monitor-layout", "--dual")
        end,
        "Dual",
    },
    {
        "p",
        function()
            spawn_terminal_command("$HOME/.local/bin/monitor-layout", "--duplicate")
        end,
        "Duplicate",
    },
}

-- }}}

-- {{{ Key bindings
-- ############################################################################
local globalkeys = mytable.join(
    -- ########################## MODES GROUP ###############################

    awful.key({ modkey }, "0", function()
        modalbind.grab({ keymap = sysmap, name = "System", stay_in_mode = false })
    end, { description = "enter system mode", group = "modes" }),

    awful.key({ modkey }, "b", function()
        modalbind.grab({ keymap = brightmap, name = "Brightness", stay_in_mode = false })
    end, { description = "enter brightness mode", group = "modes" }),

    awful.key({ modkey }, "o", function()
        modalbind.grab({ keymap = layoutmap, name = "Layout", stay_in_mode = false })
    end, { description = "enter keyboard layout mode", group = "modes" }),

    awful.key({ altkey }, "m", function()
        modalbind.grab({ keymap = monimap, name = "Monitor Layout", stay_in_mode = false })
    end, { description = "enter monitor mode", group = "modes" }),
    -- ########################################################################

    -- ########################## TAG GROUP ###############################
    -- Tag browsing
    -- awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    -- awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    -- awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

    -- Non-empty tag browsing
    -- awful.key({ altkey }, "Left", function()
    --     lain.util.tag_view_nonempty(-1)
    -- end, { description = "view  previous nonempty", group = "tag" }),
    -- awful.key({ altkey }, "Right", function()
    --     lain.util.tag_view_nonempty(1)
    -- end, { description = "view  previous nonempty", group = "tag" }),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function()
        lain.util.useless_gaps_resize(1)
    end, { description = "increment useless gaps", group = "tag" }),
    awful.key({ altkey, "Control" }, "-", function()
        lain.util.useless_gaps_resize(-1)
    end, { description = "decrement useless gaps", group = "tag" }),

    -- I could use this someday
    -- Dynamic tagging
    -- awful.key({ modkey, "Shift" }, "n", function()
    --     lain.util.add_tag()
    -- end, { description = "add new tag", group = "tag" }),
    -- awful.key({ modkey, "Control" }, "r", function()
    --     lain.util.rename_tag()
    -- end, { description = "rename tag", group = "tag" }),
    -- awful.key({ modkey, "Shift" }, "Left", function()
    --     lain.util.move_tag(-1)
    -- end, { description = "move tag to the left", group = "tag" }),
    -- awful.key({ modkey, "Shift" }, "Right", function()
    --     lain.util.move_tag(1)
    -- end, { description = "move tag to the right", group = "tag" }),
    -- awful.key({ modkey, "Shift" }, "d", function()
    --     lain.util.delete_tag()
    -- end, { description = "delete tag", group = "tag" }),
    -- ########################################################################

    -- ########################## AWESOME GROUP ###############################
    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    -- awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "e", awesome.quit, { description = "exit awesome", group = "awesome" }),
    -- awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    -- Menu
    awful.key({ modkey }, "w", function()
        awful.util.mymainmenu:show()
    end, { description = "show main menu", group = "awesome" }),

    -- Show/hide wibox
    -- awful.key({ modkey }, "b", function()
    --     for s in screen do
    --         s.mywibox.visible = not s.mywibox.visible
    --         if s.mybottomwibox then
    --             s.mybottomwibox.visible = not s.mybottomwibox.visible
    --         end
    --     end
    -- end, { description = "toggle wibox", group = "awesome" }),

    -- awful.key({ modkey }, "x", function()
    --     awful.prompt.run({
    --         prompt = "Run Lua code: ",
    --         textbox = awful.screen.focused().mypromptbox.widget,
    --         exe_callback = awful.util.eval,
    --         history_path = awful.util.get_cache_dir() .. "/history_eval",
    --     })
    -- end, { description = "lua execute prompt", group = "awesome" }),
    -- ########################################################################

    -- ########################## CLIENT GROUP ################################
    -- Default client focus
    -- awful.key({ altkey }, "j", function()
    --     awful.client.focus.byidx(1)
    -- end, { description = "focus next by index", group = "client" }),
    -- awful.key({ altkey }, "k", function()
    --     awful.client.focus.byidx(-1)
    -- end, { description = "focus previous by index", group = "client" }),

    -- By-direction client focus
    awful.key({ modkey }, "j", function()
        awful.client.focus.global_bydirection("down")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.global_bydirection("up")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus up", group = "client" }),
    awful.key({ modkey }, "h", function()
        awful.client.focus.global_bydirection("left")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l", function()
        awful.client.focus.global_bydirection("right")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus right", group = "client" }),

    -- awful.key({ modkey, "Control" }, "n", function()
    --     local c = awful.client.restore()
    --     -- Focus restored client
    --     if c then
    --         c:emit_signal("request::activate", "key.unminimize", { raise = true })
    --     end
    -- end, { description = "restore minimized", group = "client" }),

    -- Layout manipulation
    -- Default client swap
    -- awful.key({ modkey, "Shift" }, "j", function()
    --     awful.client.swap.byidx(1)
    -- end, { description = "swap with next client by index", group = "client" }),
    -- awful.key({ modkey, "Shift" }, "k", function()
    --     awful.client.swap.byidx(-1)
    -- end, { description = "swap with previous client by index", group = "client" }),

    -- By-direction client swap
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.global_bydirection("down")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with down client", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.global_bydirection("up")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with up client", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.client.swap.global_bydirection("left")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with left client", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.client.swap.global_bydirection("right")
        -- if client.focus then
        --     client.focus:raise()
        -- end
    end, { description = "swap with right client", group = "client" }),

    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    -- awful.key({ modkey }, "Tab", function()
    --     if cycle_prev then
    --         awful.client.focus.history.previous()
    --     else
    --         awful.client.focus.byidx(-1)
    --     end
    --     if client.focus then
    --         client.focus:raise()
    --     end
    -- end, { description = "cycle with previous/go back", group = "client" }),
    -- ########################################################################

    -- ########################## LAUNCHER GROUP ###############################
    -- Standard program
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "r", function()
        awful.util.spawn("rofi -show run")
    end, { description = "run a command", group = "launcher" }),
    -- awful.key({ modkey }, "r", function()
    --     awful.screen.focused().mypromptbox:run()
    -- end, { description = "run prompt", group = "launcher" }),
    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
            awful.spawn.with_shell(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]]
    -- alternatively use rofi, a dmenu-like application with more features
    -- check https://github.com/DaveDavenport/rofi for more details
    --[[ rofi
    awful.key({ modkey }, "x", function ()
            awful.spawn.with_shell(string.format("rofi -show %s -theme %s",
            'run', 'dmenu'))
        end,
        {description = "show rofi", group = "launcher"}),
    --]]

    -- App Launcher
    awful.key({ modkey }, "d", function()
        awful.util.spawn("rofi -show drun")
    end, { description = "open apps", group = "launcher" }),

    -- Dropdown application
    -- awful.key({ modkey }, "z", function()
    --     awful.screen.focused().quake:toggle()
    -- end, { description = "dropdown application", group = "launcher" }),

    -- ########################################################################

    -- ########################## LAYOUT GROUP ################################
    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),

    -- awful.key({ modkey, "Shift" }, "h", function()
    --     awful.tag.incnmaster(1, nil, true)
    -- end, { description = "increase the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "l", function()
    --     awful.tag.incnmaster(-1, nil, true)
    -- end, { description = "decrease the number of master clients", group = "layout" }),

    awful.key({ modkey, altkey }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, altkey }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),

    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next layout", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous layout", group = "layout" }),
    -- ########################################################################

    -- ########################## SCREEN GROUP ################################
    awful.key({ modkey, "Control" }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    -- ########################################################################

    -- ########################## WIDGETS GROUP ###############################
    -- Widgets popups
    -- awful.key({ altkey }, "c", function()
    --     if beautiful.cal then
    --         beautiful.cal.show(7)
    --     end
    -- end, { description = "show calendar", group = "widgets" }),
    -- awful.key({ altkey }, "h", function()
    --     if beautiful.fs then
    --         beautiful.fs.show(7)
    --     end
    -- end, { description = "show filesystem", group = "widgets" }),
    -- awful.key({ altkey }, "w", function()
    --     if beautiful.weather then
    --         beautiful.weather.show(7)
    --     end
    -- end, { description = "show weather", group = "widgets" }),
    -- ########################################################################

    -- ########################## HOTKEYS GROUP ###############################
    -- Destroy all notifications
    -- awful.key({ "Control" }, "space", function()
    --     naughty.destroy_all_notifications()
    -- end, { description = "destroy all notifications", group = "hotkeys" }),

    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ modkey }, "p", function()
        spawn_terminal_command("flameshot", "screen -c")
    end, { description = "take a screenshot of a full screen to clipboard", group = "hotkeys" }),

    awful.key({ modkey }, "z", function()
        spawn_terminal_command("flameshot", "gui -c")
    end, { description = "take a screenshot with gui to clipboard", group = "hotkeys" }),

    -- X screen locker
    -- TODO:
    -- awful.key({ altkey, "Control" }, "l", function()
    --     awful.spawn.with_shell(scrlocker)
    -- end, { description = "lock screen", group = "hotkeys" }),

    -- Use xrandr to adjust screen brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        spawn_terminal_command("$HOME/.local/bin/display-brightness", "--increase")
    end, { description = "brightness +10%", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        spawn_terminal_command("$HOME/.local/bin/display-brightness", "--decrease")
    end, { description = "brightness -10%", group = "hotkeys" }),

    -- Use pactl and pacmd to adjust volume with PulseAudio.
    awful.key({}, "XF86AudioRaiseVolume", function()
        spawn_terminal_command("$HOME/.local/bin/volume-control", "--increase")
        -- beautiful.volume.update()
    end, { description = "volume +5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        spawn_terminal_command("$HOME/.local/bin/volume-control", "--decrease")
        -- beautiful.volume.update()
    end, { description = "volume -5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioMute", function()
        spawn_terminal_command("$HOME/.local/bin/volume-control", "--toggle-mute")
        -- beautiful.volume.update()
    end, { description = "toggle mute volume", group = "hotkeys" })

    -- TODO:
    -- Command to toggle mute microphone
    -- pacmd list-sources | \
    --     grep -oP 'index: \d+' | \
    --     awk '{ print $2 }' | \
    --     xargs -I{} pactl set-source-mute {} toggle

    -- Copy primary to clipboard (terminals to gtk) -- !replace xsel with xclip!
    -- awful.key({ modkey }, "c", function()
    --     awful.spawn.with_shell("xsel | xsel -i -b")
    -- end, { description = "copy terminal to gtk", group = "hotkeys" }),
    -- -- Copy clipboard to primary (gtk to terminals)
    -- awful.key({ modkey }, "v", function()
    --     awful.spawn.with_shell("xsel -b | xsel")
    -- end, { description = "copy gtk to terminal", group = "hotkeys" })
    -- ########################################################################
)

local clientkeys = mytable.join(
    -- awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client, { description = "magnify client", group = "client" }),
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "q", function(c)
        c:kill()
    end, { description = "close the client", group = "client" }),
    awful.key(
        { modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    -- awful.key({ modkey, "Control" }, "Return", function(c)
    --     c:swap(awful.client.getmaster())
    -- end, { description = "move to master", group = "client" }),
    -- awful.key({ modkey }, "o", function(c)
    --     c:move_to_screen()
    -- end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    -- awful.key({ modkey }, "n", function(c)
    --     -- The client currently has the input focus, so it cannot be
    --     -- minimized, since minimized clients can't have the focus.
    --     c.minimized = true
    -- end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" })
    -- awful.key({ modkey, "Control" }, "m", function(c)
    --     c.maximized_vertical = not c.maximized_vertical
    --     c:raise()
    -- end, { description = "(un)maximize vertically", group = "client" }),
    -- awful.key({ modkey, "Shift" }, "m", function(c)
    --     c.maximized_horizontal = not c.maximized_horizontal
    --     c:raise()
    -- end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = mytable.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

local clientbuttons = mytable.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- ############################################################################
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

    -- TODO: Find a better solution
    -- Make Telegram Media Viewer floating by default
    {
        rule = { class = "TelegramDesktop" }, -- , instance = "Media viewer"
        properties = { floating = true },
        -- properties = {},
        -- callback = function(c)
        --     c.floating = true
        -- end
    },

    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
    -- { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- Get classname using `xprop WM_CLASS | awk -F, '{print $2}'`
    -- https://www.reddit.com/r/awesomewm/comments/2kxmph/where_do_you_get_the_instance_name_of_a_client/

    -- Set Evince to always map on the tag named "2"
    { rule = { class = "Evince" }, properties = { tag = "2" } },

    -- Set Okular to always map on the tag named "2"
    { rule = { class = "okular" }, properties = { tag = "2" } },

    -- Set Foxit Reader to always map on the tag named "2"
    { rule = { class = "Foxit Reader" }, properties = { tag = "2" } },

    -- Set Anki to always map on the tag named "2"
    { rule = { class = "Anki" }, properties = { tag = "2" } },

    -- Set Chrome to always map on the tag named "3"
    { rule = { class = "Google-chrome" }, properties = { tag = "3" } },

    -- Make polybar borders normal
    -- {
    -- rule = { class = "Polybar" },
    -- properties = { shape = gears.partially_rounded_rect(0, 70, 70, true, true, true, true, 30) },
    -- },
}
-- }}}

-- {{{ Signals
-- ############################################################################

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
    -- c.shape = gears.shape.rounded_rect
    -- or if I want to change border radius
    -- c.shape = function(cr,w,h)
    --     gears.shape.rounded_rect(cr,w,h,5)
    -- end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 16 }):setup({
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

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
-- end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

-- {{{ Autostart Programs
-- ############################################################################
-- FIX: on restart awesome sources this file -> endless loop
-- Setup monitor layout
-- spawn_terminal_command("$HOME/.local/bin/monitor-layout", "--startup")

-- Set the wallpaper
spawn_terminal_command("nitrogen", "--restore")
-- Enable transparency; add "-- config $HOME/.config/picom/picom.conf" for config to be used
-- spawn_terminal_command("picom")
spawn_terminal_command("$HOME/.local/bin/touchpad-settings")
-- Set my keyboard layout
spawn_terminal_command("$HOME/.local/bin/keyboard-layout", "--no-german")
-- Update current brightness for my custom script
spawn_terminal_command("$HOME/.config/polybar/scripts/get-brightness-on-startup.sh")
-- Enable polybar
spawn_terminal_command("$HOME/.config/polybar/launch.sh")
-- }}}
