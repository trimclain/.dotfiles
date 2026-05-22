local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar") -- will be used instead of rofi -show drun

local env = require("env")

local M = {}

-- Create a launcher widget and a main menu
local myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual", env.detect_terminal() .. " -e man awesome" },
    { "edit config", env.detect_terminal() .. " -e " .. env.editor .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}

M.main_menu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", env.detect_terminal() },
    },
})

-- Menubar configuration
menubar.utils.terminal = env.detect_terminal() -- set the terminal for applications that need it

return M
