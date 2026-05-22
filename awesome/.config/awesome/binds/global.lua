local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects
local hotkeys_popup = require("awful.hotkeys_popup")

local env = require("env")
local menu = require("ui.menu")
local utils = require("core.utils")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local M = {}

-- Mouse Buttons
-- 1 - leftclick, 2 - middleclick, 3 - rightclick, 4 - wheel up, 5 - wheel down
M.buttons = gears.table.join(
    awful.button({}, 3, function()
        menu.main_menu:toggle()
    end)
    -- scroll to move me to next tag
    -- awful.button({}, 4, awful.tag.viewprev),
    -- awful.button({}, 5, awful.tag.viewnext)
)

-- Keyboard Shortcuts
local globalkeys = gears.table.join(
    -- ########################## LAUNCHER GROUP ###############################
    awful.key({ env.modkey }, "Return", function()
        awful.spawn(env.detect_terminal())
    end, { description = "open a terminal", group = "launcher" }),

    awful.key({ env.modkey }, "b", function()
        awful.spawn(env.browser)
    end, { description = "open the browser", group = "launcher" }),

    awful.key({ env.modkey }, "r", env.run_launcher, { description = "run a command", group = "launcher" }),
    awful.key({ env.modkey }, "d", env.app_launcher, { description = "open apps", group = "launcher" }),

    -- TODO: migrate
    -- INFO: temp disabled until start using lain again
    -- -- On-the-fly useless gaps change
    -- awful.key({ altkey, "Control" }, "=", function()
    --     lain.util.useless_gaps_resize(1)
    -- end, { description = "increment useless gaps", group = "tag" }),
    -- awful.key({ altkey, "Control" }, "-", function()
    --     lain.util.useless_gaps_resize(-1)
    -- end, { description = "decrement useless gaps", group = "tag" }),

    -- ########################## AWESOME GROUP ###############################
    awful.key({ env.modkey }, "/", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ env.modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ env.modkey, "Shift" }, "e", awesome.quit, { description = "exit awesome", group = "awesome" }),
    -- TODO: different or no key?
    awful.key({ env.modkey }, "w", function()
        menu.main_menu:show()
    end, { description = "show main menu", group = "awesome" }),

    -- TODO: parse new
    -- awful.key({ modkey }, "x", function()
    --     awful.prompt.run({
    --         prompt = "Run Lua code: ",
    --         textbox = awful.screen.focused().mypromptbox.widget,
    --         exe_callback = awful.util.eval,
    --         history_path = awful.util.get_cache_dir() .. "/history_eval",
    --     })
    -- end, { description = "lua execute prompt", group = "awesome" }),

    -- ########################## CLIENT GROUP ################################
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

    -- ########################## SCREEN GROUP ################################
    -- TODO: sure?
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
    end, { description = "move client to the screen on the right", group = "screen" }),

    -- ########################## LAYOUT GROUP ################################
    -- TODO: sure this is my workflow?
    awful.key({ env.modkey, "Control" }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ env.modkey, "Control" }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),

    -- TODO: parse old
    -- awful.key({ modkey, "Shift" }, "h", function()
    --     awful.tag.incnmaster(1, nil, true)
    -- end, { description = "increase the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "l", function()
    --     awful.tag.incnmaster(-1, nil, true)
    -- end, { description = "decrease the number of master clients", group = "layout" }),

    -- TODO: sure this is my workflow?
    awful.key({ env.modkey, env.altkey }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ env.modkey, env.altkey }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),

    awful.key({ env.modkey }, "Tab", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),

    -- TODO: parse old
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

    -- ########################## HOTKEYS GROUP ###############################
    -- TODO: parse old
    -- Destroy all notifications
    -- awful.key({ "Control" }, "space", function()
    --     naughty.destroy_all_notifications()
    -- end, { description = "destroy all notifications", group = "hotkeys" }),

    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ env.modkey }, "p", function()
        utils.run_command("flameshot screen -c")
    end, { description = "take a screenshot of a full screen to clipboard", group = "hotkeys" }),

    awful.key({ env.modkey }, "s", function()
        utils.run_command("flameshot gui -c")
    end, { description = "take a screenshot with gui to clipboard", group = "hotkeys" }),

    -- Lock the screen
    awful.key({ env.altkey }, "l", function()
        -- Will use slock if `xss-lock --transfer-sleep-lock slock` was run on startup
        awful.spawn.with_shell("loginctl lock-session")
        -- awful.spawn.with_shell("xscreensaver-command -lock")
    end, { description = "lock screen", group = "hotkeys" }),

    -- Use xrandr to adjust screen brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        utils.run_command("~/.local/bin/brightness-control --increase")
    end, { description = "brightness +10%", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        utils.run_command("~/.local/bin/brightness-control --decrease")
    end, { description = "brightness -10%", group = "hotkeys" }),

    -- Use pactl and pacmd to adjust volume with PulseAudio.
    awful.key({}, "XF86AudioRaiseVolume", function()
        utils.run_command("~/.local/bin/volume-control --increase")
    end, { description = "volume +5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        utils.run_command("~/.local/bin/volume-control --decrease")
    end, { description = "volume -5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioMute", function()
        utils.run_command("~/.local/bin/volume-control --toggle-mute")
    end, { description = "toggle mute volume", group = "hotkeys" }),
    awful.key({}, "XF86AudioMicMute", function()
        utils.run_command("~/.local/bin/volume-control --toggle-micro-mute")
    end, { description = "toggle mute microphone", group = "hotkeys" }),
    awful.key({ env.altkey }, "p", function()
        utils.run_command("~/.local/bin/volume-control --toggle-micro-mute")
    end, { description = "toggle mute microphone", group = "hotkeys" })

    -- TODO: parse old
    -- Copy primary to clipboard (terminals to gtk) -- !replace xsel with xclip!
    -- awful.key({ modkey }, "c", function()
    --     awful.spawn.with_shell("xsel | xsel -i -b")
    -- end, { description = "copy terminal to gtk", group = "hotkeys" }),
    -- -- Copy clipboard to primary (gtk to terminals)
    -- awful.key({ modkey }, "v", function()
    --     awful.spawn.with_shell("xsel -b | xsel")
    -- end, { description = "copy gtk to terminal", group = "hotkeys" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tag_keys = {}
-- WARN: not all 9 are always defined
for i = 1, 9 do
    -- View tag only.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey }, "#" .. i + 9, function()
        local s = awful.screen.focused()
        local tag = s.tags[i]
        if tag then
            tag:view_only()
        end
    end, { description = "view tag #" .. i, group = "tag" })
    -- Toggle tag display.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control" }, "#" .. i + 9, function()
        local s = awful.screen.focused()
        local tag = s.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, { description = "toggle tag #" .. i, group = "tag" })
    -- Move client to tag.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, { description = "move focused client to tag #" .. i, group = "tag" })
    -- Toggle tag on focused client.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control", "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end, { description = "toggle focused client on tag #" .. i, group = "tag" })
end

M.keys = gears.table.join(globalkeys, table.unpack(tag_keys))

return M
