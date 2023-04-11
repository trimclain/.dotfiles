local M = {}

--- Print the given object
---@param obj table | string | integer
function _G.P(obj)
    print(vim.inspect(obj))
end

--- Join path segments to a full path
---@vararg string folder or file names
---@return string full path to the file or folder
function M.join(...)
    local uv = vim.loop
    local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"
    return table.concat({ ... }, path_sep)
end

-------------------------------------------------------------------------------
-- From lazyvim.util.init.lua
-------------------------------------------------------------------------------
---@param on_attach function(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

--- Check if a plugin is installed and enabled
---@param plugin string
function M.has_plugin(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

--- Execute command on VeryLazy event from lazy.nvim
---@param fn function
function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            fn()
        end,
    })
end

--- List options passed to a plugin, if the plugin is used
---@param name string
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

-- Return a function that calls telescope.
---@param builtin string
---@param opts table | nil
function M.telescope(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
        builtin = params.builtin
        opts = params.opts or {}
        -- for `files`, git_files or find_files will be chosen depending on .git
        if builtin == "files" then
            -- Check if cwd is in a git worktree
            local in_worktree = require("telescope.utils").get_os_command_output(
                { "git", "rev-parse", "--is-inside-work-tree" },
                vim.loop.cwd()
            )
            if in_worktree[1] == "true" then
                opts.show_untracked = true
                builtin = "git_files"
            else
                opts.hidden = true
                builtin = "find_files"
            end
        end
        require("telescope.builtin")[builtin](opts)
    end
end

--- Fuzzy find in current buffer
M.curr_buf_search = function()
    local opt = require("telescope.themes").get_dropdown({ height = 10, previewer = false })
    require("telescope.builtin").current_buffer_fuzzy_find(opt)
end

-- local diagnostics_active = true
-- function M.toggle_diagnostics()
--     diagnostics_active = not diagnostics_active
--     if diagnostics_active then
--         vim.diagnostic.show()
--     else
--         vim.diagnostic.hide()
--     end
-- end
-------------------------------------------------------------------------------

-- -- ############################################################################
-- -- OPTION CHANGE
-- -- ############################################################################

-- --- Get the value of option current for current buffer
-- ---@param opt string vim.opt.optionname
-- function M.get_buf_option(opt)
--     local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
--     if not status_ok then
--         return nil
--     else
--         return buf_option
--     end
-- end

--
-- --- Toggle the value of vim option
-- ---@param option string vim.opt.optioname
-- function M.toggle_option(option)
--     local value = not vim.api.nvim_get_option_value(option, {})
--     vim.opt[option] = value
--     vim.notify(option .. " set to " .. tostring(value))
-- end
--
-- --- Change current tabstop, softtabstop and shiftwidth values between 2 and 4
-- function M.toggle_shiftwidth()
--     local value = vim.api.nvim_get_option_value("shiftwidth", {})
--     if value == 4 then
--         value = 2
--     else
--         value = 4
--     end
--     vim.opt.tabstop = value -- insert 2 spaces for \t
--     vim.opt.softtabstop = value -- insert 2 spaces for <Tab> and <BS> keypresses
--     vim.opt.shiftwidth = value -- the number of spaces inserted for each indentation level
--     vim.notify("tabstop, softtabstop and shiftwidth are set to " .. tostring(value))
-- end

-- -- ############################################################################
-- -- FORMATTING
-- -- ############################################################################
-- local format_on_save = vim.api.nvim_create_augroup("format_on_save", { clear = true })
--
-- local extension_table = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.html", "*.lua", "*.py" }
-- local filetype_table = {
--     "javascript",
--     "typescript",
--     "javascriptreact",
--     "typescriptreact",
--     "css",
--     "html",
--     "lua",
--     "python",
-- }
--
-- function M.update_autoformat_status()
--     -- check for filetype to be in the filetype_table
--     local filetype = vim.bo.filetype
--     if not vim.tbl_contains(filetype_table, filetype) then
--         vim.g.autoformat_status = ""
--         return
--     end
--
--     -- filter out floating windows: vim.api.nvim_win_get_config(0).relative == ""
--
--     -- check for existing autocmd
--     if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
--         -- vim.g.autoformat_status = ""
--         -- vim.g.autoformat_status = ""
--         vim.g.autoformat_status = ""
--         return
--     end
--
--     -- vim.g.autoformat_status = ""
--     vim.g.autoformat_status = ""
-- end
--
-- --- Remove existing autogroup to disable autocommand
-- ---@param name string the name of the existing autogroup
-- function M.remove_augroup(name)
--     if vim.fn.exists("#" .. name) == 1 then
--         vim.cmd("au! " .. name)
--     end
-- end
--
-- function M.init_format_on_save()
--     vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = extension_table,
--         callback = function()
--             vim.lsp.buf.format()
--         end,
--         group = format_on_save,
--     })
-- end
--
-- function M.enable_format_on_save()
--     local filetype = vim.bo.filetype
--     local extension = vim.fn.expand "%:e"
--     local filename = vim.fn.expand "%:t"
--     local pattern
--     -- Fix the case when shebang is used but there's no extension
--     if extension then
--         pattern = "*." .. extension
--     else
--         pattern = filename
--     end
--     if vim.tbl_contains(filetype_table, filetype) then
--         vim.api.nvim_create_autocmd("BufWritePre", {
--             pattern = pattern,
--             callback = function()
--                 vim.lsp.buf.format()
--             end,
--             group = format_on_save,
--         })
--         vim.g.autoformat_status = ""
--         vim.notify "Enabled format on save"
--     else
--         vim.notify "No formmatting is available for this filetype"
--     end
-- end
--
-- function M.disable_format_on_save()
--     M.remove_augroup "format_on_save"
--     vim.g.autoformat_status = ""
--     vim.notify "Disabled format on save"
-- end
--
-- function M.toggle_format_on_save()
--     if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
--         M.enable_format_on_save()
--     else
--         M.disable_format_on_save()
--     end
-- end
--
-- -- bang is used to tell nvim to redefine the command if it already exists
-- vim.api.nvim_create_user_command("FormattingToggle", M.toggle_format_on_save, { bang = true })
--
-- TODO: is there an easier way using Lazyvim's config?
-- Formatting
-- require("trimclain.utils").init_format_on_save()
-- vim.api.nvim_create_augroup("format_on_save_status", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorMovedI" }, {
--     callback = function()
--         require("trimclain.utils").update_autoformat_status()
--     end,
--     desc = "Update formatting status icon",
--     group = "format_on_save_status",
-- })
--
-- -- ############################################################################
-- TODO: do I still use this?
-- M.ToggleQFList = function()
--     if vim.g.qflist_global == 1 then
--         vim.cmd.cclose()
--     else
--         vim.cmd.copen()
--     end
-- end
-- Autocommands for QuickFixList
-- local quickfix_toggle = vim.api.nvim_create_augroup("quickfix_toggle", { clear = true })
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     pattern = "quickfix",
--     callback = function()
--         vim.g.qflist_global = 1
--     end,
--     desc = "Update quickfixlist status variable on open",
--     group = quickfix_toggle,
-- })
-- vim.api.nvim_create_autocmd("BufWinLeave", {
--     pattern = "*",
--     callback = function()
--         vim.g.qflist_global = 0
--     end,
--     desc = "Update quickfixlist status variable on close",
--     group = quickfix_toggle,
-- })
-- -- ############################################################################

vim.cmd([[
    " Empty all Registers
    fun! EmptyRegisters()
        let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
        for r in regs
            call setreg(r, [])
        endfor
    endfun
]])

vim.cmd([[
    function! HandleURL()
        let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
        echo "Opened ".s:uri
        if s:uri != ""
            silent exec "!xdg-open '".s:uri."'"
        else
            echo "No URI found in line."
        endif
    endfunction
]])

return M
