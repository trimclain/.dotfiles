local awful = require("awful")

local utils = require("utils")

local detect_terminal = require("env.terminal").get_name

local M = {}

local _spawn = function()
    awful.spawn(detect_terminal() .. " -e top")
end

function M.spawn()
    _spawn()
end

utils.find_first_executable({ "btop", "htop" }, function(cmd, _)
    if cmd then
        _spawn = function()
            awful.spawn(detect_terminal() .. " -e " .. cmd)
        end
    end
end)

return M
