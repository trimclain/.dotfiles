local awful = require("awful") -- Everything related to window managment

local utils = require("utils")

local M = {}

local _run_launcher = function()
    awful.screen.focused().mypromptbox:run()
end

function M.run_launcher()
    _run_launcher()
end

local _app_launcher = function()
    require("menubar").show()
end

function M.app_launcher()
    _app_launcher()
end

utils.check_command_executable("rofi", function(is_installed, _, _)
    if is_installed then
        _run_launcher = function()
            awful.spawn("rofi -show run")
        end
        _app_launcher = function()
            awful.spawn("rofi -show drun")
        end
    end
end)

return M
