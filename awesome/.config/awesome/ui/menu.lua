local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

local env = require("core.env")

local M = {}

-- Create a launcher widget and a main menu
local myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual", env.terminal .. " -e man awesome" },
    { "edit config", env.terminal .. " -e " .. env.editor .. " " .. awesome.conffile },
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
        { "open terminal", env.terminal },
    },
})

M.launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = M.main_menu })

-- Menubar configuration
menubar.utils.terminal = env.terminal -- set the terminal for applications that need it

return M
