local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library

local client_binds = require("binds.client")
local env = require("env")

-- Rules to apply to new clients (through the "manage" signal).
-- INFO: Get class name using `xprop WM_CLASS | awk -F, '{print $2}'`
-- https://www.reddit.com/r/awesomewm/comments/2kxmph/where_do_you_get_the_instance_name_of_a_client/
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            -- make every new client open to the right in the tile layout
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_binds.keys,
            buttons = client_binds.buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            -- don't respect a window’s size hints provided by the application
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

                "Yad",
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

    -- Fix Telegram media viewer being out of screen
    {
        rule_any = { name = { "Media viewer" } },
        properties = {
            floating = true,
            fullscreen = false,
            maximized = false,
            titlebars_enabled = false,
        },
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = env.enable_titlebars } },

    -- Set Anki to always map on the tag named "2"
    -- { rule = { class = "Anki" }, properties = { tag = "2" } },
}
