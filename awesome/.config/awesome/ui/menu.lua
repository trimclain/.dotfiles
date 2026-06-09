local awful = require("awful") -- Everything related to window managment
local beautiful = require("beautiful") -- Theme handling library
local hotkeys_popup = require("awful.hotkeys_popup")

local env = require("env")

local M = {}

-- Create a launcher widget and a main menu
function M.create_main_menu()
    local myawesomemenu = {
        {
            "hotkeys",
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end,
        },
        { "manual", env.detect_terminal() .. " -e man awesome" },
        { "edit config", env.detect_editor() .. " " .. awesome.conffile },
        { "restart", awesome.restart },
        {
            "quit",
            function()
                awesome.quit()
            end,
        },
    }

    local main_menu = awful.menu({
        items = {
            { "awesome", myawesomemenu, beautiful.awesome_icon },
            { "open terminal", env.detect_terminal() },
        },
    })

    -- Hide the menu when the mouse leaves it
    main_menu.wibox:connect_signal("mouse::leave", function()
        if
            not main_menu.active_child
            or (main_menu.wibox ~= mouse.current_wibox and main_menu.active_child.wibox ~= mouse.current_wibox)
        then
            main_menu:hide()
        else
            main_menu.active_child.wibox:connect_signal("mouse::leave", function()
                if main_menu.wibox ~= mouse.current_wibox then
                    main_menu:hide()
                end
            end)
        end
    end)

    return main_menu
end

return M
