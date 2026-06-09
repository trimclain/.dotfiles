local utils = require("utils")

local M = {}

local _tui_editor = "vim"
local _gui_editor = ""

function M.get_name()
    if _gui_editor == "" then
        local terminal = require("env.terminal").get_name()
        return terminal .. " -e " .. _tui_editor
    end
    return _gui_editor
end

utils.check_command_executable("nvim", function(is_installed, _, _)
    if is_installed then
        _tui_editor = "nvim"
    end
end)

utils.check_command_executable("neovide", function(is_installed, _, _)
    if is_installed then
        _gui_editor = "neovide"
    end
end)

return M
