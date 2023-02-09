local M = {}

-- ############################################################################
-- NICE TO HAVE
-- ############################################################################

--- Print the given object
---@param obj table | string | integer
function _G.P(obj)
    print(vim.inspect(obj))
end

-- INFO: use table.concat
--- Concatenate 2 lua tables
-- function M.tbl_concat(a, b)
--     local result = vim.deepcopy(a)
--     for _, value in ipairs(b) do
--         table.insert(result, value)
--     end
--     return result
-- end

--- Return true if s is either "" or nil
---@param s string | table
---@return boolean
function M.isempty(s)
    return s == nil or s == ""
end

--- Check if a directory exists in this path
---@param file string path to the file
---@return boolean
function M.exists(file)
    local ok, _, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok == true
end

--- Check if a directory exists in this path
---@param path string path to the file
---@return boolean
function M.isdir(path)
    -- "/" works on both Unix and Windows
    return M.exists(path .. "/")
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

--- Join path segments to a full path
---@vararg string folder or file names
---@return string result full path to the file or folder
function M.join_paths(...)
    local uv = vim.loop
    local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
    local args = {...}

    -- Check if every given file or folder exists
    local tmp_path = args[1]
    table.remove(args, 1)
    for _, v in ipairs(args) do
        tmp_path = tmp_path .. path_sep .. tostring(v)
        if not M.exists(tmp_path) then
            print("Error: " .. tmp_path .. " doesn't exists")
        end
    end

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

-- Someday?
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

-- TODO: switch from horizontal split to vertical and back
-- https://stackoverflow.com/questions/1269603/to-switch-from-vertical-split-to-horizontal-split-fast-in-vim

-- ############################################################################
-- SMART QUIT
-- ############################################################################

-- PROBLEM: This doesn't work when it is passed to a keymap (always returns 1). Maybe will be fixed someday.
--- Return the number of open buffers (credit to tj and telescope)
---@return integer bufnum number of open buffer
-- function M.get_num_of_open_bufs()
--     local buffers = {}
--     local bufnrs = vim.tbl_filter(function(b)
--         if 1 ~= vim.fn.buflisted(b) then
--             return false
--         end
--         return true
--     end, vim.api.nvim_list_bufs())
--     if not next(bufnrs) then
--         return 0
--     end
--     return #bufnrs
-- end

--- Quit neovim if the last open buffer is empty or from the filetypes table
---@return string cmd command to run on smart quit
-- function M.smart_quit()
--     local num = M.get_num_of_open_bufs()
--     if num == 1 then
--         -- return "<cmd>qa<cr>"
--         return '<cmd>echo "ACTUALLY ' .. tostring(num) .. ' QUTTING"<cr>'
--     end
--     return '<cmd>echo "NOT QUTTING YET..."<cr>'
--     -- return "<cmd>Bdelete<cr>"
-- end

-- ############################################################################
-- OPTION CHANGE
-- ############################################################################

--- Toggle the value of vim option
---@param option string vim.opt.optioname
function M.toggle_option(option)
    local value = not vim.api.nvim_get_option_value(option, {})
    vim.opt[option] = value
    vim.notify(option .. " set to " .. tostring(value))
end

--- Change current tabstop, softtabstop and shiftwidth values between 2 and 4
function M.toggle_shiftwidth()
    local value = vim.api.nvim_get_option_value("shiftwidth", {})
    if value == 4 then
        value = 2
    else
        value = 4
    end
    vim.opt.tabstop = value -- insert 2 spaces for \t
    vim.opt.softtabstop = value -- insert 2 spaces for <Tab> and <BS> keypresses
    vim.opt.shiftwidth = value -- the number of spaces inserted for each indentation level
    vim.notify("tabstop, softtabstop and shiftwidth are set to " .. tostring(value))
end

-- ############################################################################
-- FORMATTING
-- ############################################################################
local format_on_save = vim.api.nvim_create_augroup("format_on_save", { clear = true })

local extension_table = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.html", "*.lua", "*.py" }
local filetype_table = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "css",
    "html",
    "lua",
    "python",
}

function M.update_autoformat_status()
    -- check for filetype to be in the filetype_table
    local filetype = vim.bo.filetype
    if not vim.tbl_contains(filetype_table, filetype) then
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
        pattern = extension_table,
        callback = function()
            vim.lsp.buf.format()
        end,
        group = format_on_save,
    })
end

function M.enable_format_on_save()
    local filetype = vim.bo.filetype
    local extension = vim.fn.expand "%:e"
    local filename = vim.fn.expand "%:t"
    local pattern
    -- Fix the case when shebang is used but there's no extension
    if extension then
        pattern = "*." .. extension
    else
        pattern = filename
    end
    if vim.tbl_contains(filetype_table, filetype) then
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = pattern,
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

-- bang is used to tell nvim to redefine the command if it already exists
vim.api.nvim_create_user_command("FormattingToggle", M.toggle_format_on_save, { bang = true })

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
-- function M.get_list_of_config_files()
--     local config_dir = M.get_config_dir()
--     local lua_config_dir = M.join_paths(config_dir, "lua", "trimclain")
--     local lsp_settings_dir = M.join_paths(lua_config_dir, "lsp", "settings")
--     local stylua_conf = M.join_paths(config_dir, "stylua.toml")
--     local packer_compiled_conf = M.join_paths(config_dir, "plugin", "packer_compiled.lua")
--     local command = "find "
--         .. config_dir
--         .. "/ "
--         .. lua_config_dir
--         .. "/ "
--         .. lsp_settings_dir
--         .. "/ -mindepth 1 -maxdepth 2 -type f -not \\( -path "
--         .. stylua_conf
--         .. " -o -path "
--         .. packer_compiled_conf
--         .. ' \\) -printf "%f\n"'

--     local config_files = vim.fn.systemlist(command)
--     return config_files
-- end

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
    if not M.exists(plugin_updated_at_filename) then
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

vim.cmd [[
    " Empty all Registers
    fun! EmptyRegisters()
        let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
        for r in regs
            call setreg(r, [])
        endfor
    endfun
]]

-- local check_backspace = function()
--     local col = vim.fn.col "." - 1
--     return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
-- end
-- vim.fn.getline()
vim.cmd [[
    function! HandleURL()
        let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
        echo "Opened ".s:uri
        if s:uri != ""
            silent exec "!xdg-open '".s:uri."'"
        else
            echo "No URI found in line."
        endif
    endfunction
]]

return M
