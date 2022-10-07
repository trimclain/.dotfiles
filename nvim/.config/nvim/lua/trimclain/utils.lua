local M = {}

-- get length of current word
-- function M.get_word_length()
--     local word = vim.fn.expand "<cword>"
--     return #word
-- end

-- local diagnostics_active = true
-- function M.toggle_diagnostics()
--     diagnostics_active = not diagnostics_active
--     if diagnostics_active then
--         vim.diagnostic.show()
--     else
--         vim.diagnostic.hide()
--     end
-- end

--- Return true if s is either "" or nil
---@param s string | table
---@return boolean
function M.isempty(s)
    return s == nil or s == ""
end

--- Check if a file exists
---@param name string path to the file
function M.file_exists(name)
    local f = io.open(name, "r")
    if f then
        f:close()
    end
    return f ~= nil
end

--- Get the value of option current for current buffer
---@param opt string vim.opt.optionname
function M.get_buf_option(opt)
    local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
    if not status_ok then
        return nil
    else
        return buf_option
    end
end

--- Toggle the value of vim option
---@param option string vim.opt.optioname
function M.toggle_option(option)
    local value = not vim.api.nvim_get_option_value(option, {})
    vim.opt[option] = value
    vim.notify(option .. " set to " .. tostring(value))
end

--- Change current shiftwidth value between 2 and 4
function M.toggle_shiftwidth()
    local value = vim.api.nvim_get_option_value("shiftwidth", {})
    if value == 4 then
        value = 2
    else
        value = 4
    end
    vim.opt.shiftwidth = value
    vim.notify("shiftwidth" .. " set to " .. tostring(value))
end

--- Joing path segments that were passed as input
---@vararg string folder or file names
---@return string result full path to the file or folder
function M.join_paths(...)
    local uv = vim.loop
    local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

    local result = table.concat({ ... }, path_sep)
    return result
end

--- Remove existing autogroup to disable autocommand
---@param name string the name of the existing autogroup
function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

-- Nice Stuff from TJ
-- local has = function(x)
--     return vim.fn.has(x) == 1
-- end
--
-- local executable = function(x)
--     return vim.fn.executable(x) == 1
-- end
--
-- local is_wsl = (function()
--     local output = vim.fn.systemlist "uname -r"
--     return not not string.find(output[1] or "", "WSL")
-- end)()
-- local is_mac = has "macunix"
-- local is_linux = not is_wsl and not is_mac

-- ############################################################################
-- FORMATTING
-- ############################################################################
local format_on_save = vim.api.nvim_create_augroup("format_on_save", { clear = true })

local pattern_list = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.html", "*.lua", "*.py" }

function M.update_autoformat_status()
    -- check for filetype to be in the pattern_list
    local pattern = "*." .. vim.fn.expand "%:e"
    if not vim.tbl_contains(pattern_list, pattern) then
        vim.g.autoformat_status = ""
        return
    end

    -- filter out floating windows: vim.api.nvim_win_get_config(0).relative == ""

    -- check for existing autocmd
    if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
        -- vim.g.autoformat_status = ""
        -- vim.g.autoformat_status = ""
        vim.g.autoformat_status = ""
        return
    end

    -- vim.g.autoformat_status = ""
    vim.g.autoformat_status = ""
end

function M.init_format_on_save()
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = pattern_list,
        callback = function()
            vim.lsp.buf.format()
        end,
        group = format_on_save,
    })
end

function M.enable_format_on_save()
    local pattern = "*." .. vim.fn.expand "%:e"
    if vim.tbl_contains(pattern_list, pattern) then
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = pattern_list,
            callback = function()
                vim.lsp.buf.format()
            end,
            group = format_on_save,
        })
        vim.g.autoformat_status = ""
        vim.notify "Enabled format on save"
    else
        vim.notify "No formmatting is available for this filetype"
    end
end

function M.disable_format_on_save()
    M.remove_augroup "format_on_save"
    vim.g.autoformat_status = ""
    vim.notify "Disabled format on save"
end

function M.toggle_format_on_save()
    if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
        M.enable_format_on_save()
    else
        M.disable_format_on_save()
    end
end

vim.cmd [[ command! FormattingToggle execute 'lua require("trimclain.utils").toggle_format_on_save()' ]]

-- ############################################################################
-- AUTOSOURCE CONFIG
-- ############################################################################

--- Get the full path to nvim config
---@return string
function M.get_config_dir()
    return vim.call("stdpath", "config")
end

--- Get the list of every file in my nvim config
---@return table config_files list of config files
function M.get_list_of_config_files()
    local config_dir = M.get_config_dir()
    local lua_config_dir = M.join_paths(config_dir, "lua", "trimclain")
    local lsp_settings_dir = M.join_paths(lua_config_dir, "lsp", "settings")
    local stylua_conf = M.join_paths(config_dir, "stylua.toml")
    local packer_compiled_conf = M.join_paths(config_dir, "plugin", "packer_compiled.lua")
    local command = "find "
        .. config_dir
        .. "/ "
        .. lua_config_dir
        .. "/ "
        .. lsp_settings_dir
        .. "/ -mindepth 1 -maxdepth 2 -type f -not \\( -path "
        .. stylua_conf
        .. " -o -path "
        .. packer_compiled_conf
        .. ' \\) -printf "%f\n"'

    local config_files = vim.fn.systemlist(command)
    return config_files
end

-- ############################################################################
-- RESTART NEOVIM
-- ############################################################################

-- Credit to JoosepAlviste

--- Bust the cache of all required Lua files. After running this, each require() would re-run the file.
local function unload_all_modules()
    -- Lua patterns for the modules to unload
    local unload_modules = {
        "^j.",
    }

    for k, _ in pairs(package.loaded) do
        for _, v in ipairs(unload_modules) do
            if k:match(v) then
                package.loaded[k] = nil
                break
            end
        end
    end
end

--- Reload all vim modules
function M.reload()
    -- Stop LSP
    vim.cmd.LspStop()

    -- Unload all already loaded modules
    unload_all_modules()

    -- Source init.lua
    vim.cmd.luafile(M.join_paths(os.getenv "HOME", ".config", "nvim", "init.lua"))
end

--- Restart Vim without having to close and run again
function M.restart()
    -- Reload config
    M.reload()

    -- Manually run VimEnter autocmd to emulate a new run of Vim
    vim.cmd.doautocmd "VimEnter"
end

-- ############################################################################

--- Execute `PackerSync` every day automatically so that we are always up to date!
--- The last saved date is saved into `XDG_CACHE_HOME/nvim/.plugins_updated_at`.
function M.update_plugins_every_day()
    local plugin_updated_at_filename = M.join_paths(vim.call("stdpath", "cache"), ".plugins_updated_at")
    if not M.file_exists(plugin_updated_at_filename) then
        vim.fn.writefile({}, plugin_updated_at_filename)
    end

    local today = os.date "%Y-%m-%d"

    local file = io.open(plugin_updated_at_filename)
    local contents = file:read "*a"
    if contents ~= today then
        vim.fn.execute "PackerSync"
        file = io.open(plugin_updated_at_filename, "w")
        file:write(today)
    end

    file:close()
end

M.ToggleQFList = function()
    if vim.g.qflist_global == 1 then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end

-- TODO: rewrite in lua
vim.cmd [[
    " Empty all Registers
    fun! EmptyRegisters()
        let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
        for r in regs
            call setreg(r, [])
        endfor
    endfun
]]

vim.cmd [[
    function! HandleURL()
        let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
        echo s:uri
        if s:uri != ""
            silent exec "!xdg-open '".s:uri."'"
        else
            echo "No URI found in line."
        endif
    endfunction
]]

--- Print the given table
---@param tbl table
function _G.P(tbl)
    print(vim.inspect(tbl))
end

return M
