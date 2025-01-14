local M = {}

--- Print the given object and return it
---@param obj table | string | number
---@return table | string | number obj
function _G.P(obj)
    print(vim.inspect(obj))
    return obj
end

--- Check if a file exists
---@param name string? path to the file
function M.file_exists(name)
    if not name then
        return false
    end
    return vim.fn.filereadable(name) == 1
end

--- Check if a directory exists
---@param name string path to the directory
function M.dir_exists(name)
    return vim.fn.isdirectory(name) == 1
end

--- Check if a plugin is installed and enabled
---@param plugin string
function M.has_plugin(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
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
---@return table
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

--- Return true if vim was opened from a git repository
---@return boolean
M.in_git_worktree = function()
    return require("telescope.utils").get_os_command_output(
        { "git", "rev-parse", "--is-inside-work-tree" },
        vim.uv.cwd()
    )[1] == "true"
end

-- Return a function that calls telescope.
---@param builtin string
---@param opts table | nil
---@param theme string | nil
function M.telescope(builtin, opts, theme)
    local params = { builtin = builtin, opts = opts, theme = theme }
    return function()
        builtin = params.builtin

        -- theme can be "dropdown", "cursor" or "ivy"
        -- if params.theme == "default" then
        -- FIX: broken with any theme, stick to default for now
        opts = params.opts or {}
        -- else
        --     opts = require("telescope.themes").get_dropdown(params.opts or {})
        -- end

        -- for `files`, git_files or find_files will be chosen depending on .git
        if builtin == "files" then
            -- Check if cwd is in a git worktree
            builtin = M.in_git_worktree() and "git_files" or "find_files"
        end
        require("telescope.builtin")[builtin](opts)
    end
end

--- Find neovim config files in telescope
function M.config_files()
    M.telescope("find_files", { cwd = vim.fn.stdpath("config") })()
end

--- Choose a project to work on from my $PROJECTLIST using Telescope
M.open_project = function()
    local projectlist = vim.env.PROJECTLIST
    if not M.file_exists(projectlist) then
        vim.notify("Project List not found", vim.log.levels.ERROR, { title = "Project Manager" })
        return
    end

    local pickers = require("telescope.pickers")
    local sorters = require("telescope.sorters")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    ---@diagnostic disable-next-line: missing-parameter
    pickers
        .new({
            results_title = "My Projects",
            finder = finders.new_oneshot_job({ "cat", projectlist }, {}),
            sorter = sorters.get_fuzzy_file(),
            attach_mappings = function(_, map)
                -- Define custom action when an item is selected
                map("i", "<CR>", function(prompt_bufnr)
                    -- Get the selected entry
                    local selection = action_state.get_selected_entry()[1]
                    -- Close the picker
                    actions.close(prompt_bufnr)
                    vim.notify("Opened " .. selection, vim.log.levels.INFO, { title = "Project Manager" })
                    vim.cmd.cd(selection)
                    -- Open files in telescope
                    M.telescope("files")()
                    -- require("neo-tree.command").execute({ toggle = true, dir = selection })
                end)
                return true
            end,
        })
        :find()
end

-------------------------------------------------------------------------------

--- Fuzzy find in current buffer
M.curr_buf_search = function()
    -- FIX: broken with any theme
    -- local opt = require("telescope.themes").get_dropdown({ height = 10, previewer = false })
    require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
end

-------------------------------------------------------------------------------
-- OPTION CHANGE
-------------------------------------------------------------------------------

--- Use vim.notify to send INFO notifications
---@param msg string
---@param title string
local function notify(msg, title)
    vim.notify(msg, vim.log.levels.INFO, { title = title })
end

--- Implement python's str.capitalize() method
---@param str string
---@return string
local function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

--- Get nvim option value
---@param option string
---@return string | boolean | number
local function get_option(option)
    return vim.api.nvim_get_option_value(option, {})
end

--- Set nvim option value
---@param option string
---@param value string | boolean | number
local function set_option(option, value)
    vim.opt[option] = value
end

--- Toggle the value of vim option
---@param option string vim.opt.optioname
function M.toggle_option(option)
    local value = get_option(option)
    local status = value and " disabled" or " enabled"
    set_option(option, not value)
    notify(capitalize(option) .. status, "Option Toggler")
end

--- Change current tabstop, softtabstop and shiftwidth values between 2 and 4
function M.toggle_shiftwidth()
    local value = get_option("shiftwidth")
    value = value == 4 and 2 or 4
    set_option("tabstop", value) -- insert 2 or 4 spaces for \t
    set_option("shiftwidth", value) -- the number of spaces inserted for each indentation level
    notify("Tab Size is set to " .. tostring(value) .. " spaces", "Tab Size Toggler")
end

--- Toggle conceallevel value between 0 and 2
function M.toggle_conceallevel()
    local value = get_option("conceallevel")
    value = value == 2 and 0 or 2
    set_option("conceallevel", value)
    notify("Conceallevel is set to " .. tostring(value), "Conceallevel Toggler")
end

local diagnostics_active = true
--- Show/Hide LSP diagnostics
function M.toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
        notify("Diagnostics enabled", "Diagnostics Toggler")
    else
        vim.diagnostic.hide()
        notify("Diagnostics disabled", "Diagnostics Toggler")
    end
end

-------------------------------------------------------------------------------

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

-- Inspired by https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/keymaps.lua
M.toggle_quickfix = function()
    -- ignore error messages and restore the cursor to the original window when opening the list
    local silent_mods = { mods = { silent = true, emsg_silent = true } }
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd.cclose(silent_mods)
    -- elseif #vim.fn.getqflist() > 0 then
    else
        -- local win = vim.api.nvim_get_current_win()
        vim.cmd.copen(silent_mods)
        -- if win ~= vim.api.nvim_get_current_win() then
        --     vim.cmd.wincmd("p")
        -- end
    end
end

--- Empty all Registers
function M.empty_registers()
    local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'
    for r in regs:gmatch("%g") do -- %g matches all printable characters except space
        vim.fn.setreg(r, {})
    end
end

--- Toggle current file being executable
function M.toggle_executable()
    local file = vim.fn.expand("%:p")
    vim.cmd.write()
    if vim.fn.executable(file) == 0 then
        ---@diagnostic disable-next-line: assign-type-mismatch
        vim.system({ "chmod", "+x", file }):wait()
        notify("This file is now executable", "Executer")
    else
        ---@diagnostic disable-next-line: assign-type-mismatch
        vim.system({ "chmod", "-x", file }):wait()
        notify("This file is now not executable", "Executer")
    end
end

-------------------------------------------------------------------------------
-- From astronvim/utils/init.lua
-------------------------------------------------------------------------------
--- Open a URL with the current operating system
---@param path string The path of the file to open with the system opener
function M.system_open(path)
    local cmd
    if jit.os:find("Windows") and vim.fn.executable("explorer") == 1 then
        cmd = { "cmd.exe", "/K", "explorer" }
    elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
        cmd = { "xdg-open" }
    elseif (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1) and vim.fn.executable("open") == 1 then
        cmd = { "open" }
    end
    if not cmd then
        vim.notify("Available system opening tool not found!", vim.log.levels.ERROR)
    end
    vim.fn.jobstart(vim.fn.extend(cmd, { path }), { detach = true })
end

--- Find URL in current line and open it with the current operating system
function M.open_url()
    --- regex used for matching a valid URL/URI string
    local url_matcher =
        "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"
    local url = vim.fn.matchstr(vim.fn.getline("."), url_matcher)
    if url ~= "" then
        notify("Opened " .. url, "URL Handler")
        M.system_open(url)
    else
        notify("No URL found", "URL Handler")
    end
end

--- Open the path under cursor in github
function M.open_github_url()
    local url = vim.fn.expand("<cfile>")
    if url ~= "" then
        url = "https://github.com/" .. url
        notify("Opened " .. url, "Github URL Handler")
        M.system_open(url)
    else
        notify("No Github URL found", "Github URL Handler")
    end
end
-------------------------------------------------------------------------------

return M
