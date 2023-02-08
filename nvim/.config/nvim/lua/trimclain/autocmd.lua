-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("highlight_on_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            -- higroup = "IncSearch",
            -- higroup = "Substitute",
            higroup = "Search",
            timeout = 100,
            on_macro = true,
            on_visual = true,
        }
    end,
    desc = "Highlight text on yank",
    group = highlight_group,
})

-- Close these filetypes with a single keypress instead of :q
local filetype_group = vim.api.nvim_create_augroup("filetype_group", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf",
        "help",
        "man",
        "null-ls-info",
        "startuptime",
        "fugitive",
        "Jaq",
        "spectre_panel",
        -- "lir",
        -- "DressingSelect",
        -- "tsplayground",
        -- "Markdown",
    },
    callback = function()
        vim.cmd [[
            nnoremap <silent> <buffer> q :close<CR>
            nnoremap <silent> <buffer> <esc> :close<CR>
            set nobuflisted
        ]]
    end,
    desc = "Set these filetypes to close with q-press and to not be in the buffers list",
    group = filetype_group,
})

-- Enable spell in following filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown", "NeogitCommitMessage" },
    callback = function()
        vim.opt_local.spell = true
    end,
    desc = "Enable builin spellcheck in following filetypes",
    group = filetype_group,
})

-- If I use cursorline someday
-- Hide cursorline in insert mode
-- vim.api.nvim_create_augroup("cursorline_toggle", { clear = true })
-- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
--     pattern = "*",
--     command = "set cursorline",
--     desc = "Enable cursorline in normal mode",
--     group = "cursorline_toggle",
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
--     pattern = "*",
--     command = "set nocursorline",
--     desc = "Disable cursorline in insert mode",
--     group = "cursorline_toggle",
-- })

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- local reload_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "packer.lua",
--     command = "source <afile> | PackerSync",
--     desc = "Run PackerSync after saving plugins.lua",
--     group = reload_packer,
-- })

-- Autocmd for PackerSync everyday
-- vim.api.nvim_create_augroup("packersync_on_startup", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         require("trimclain.utils").update_plugins_every_day()
--     end,
--     desc = "Daily update plugins on startup",
--     group = "packersync_on_startup",
-- })

-- Autocommand to trim whitespaces
vim.api.nvim_create_augroup("TrimWhitespacesOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e",
    desc = "Delete useless whitespaces when saving the file",
    group = "TrimWhitespacesOnSave",
})

-- Formatting
-- require("trimclain.utils").init_format_on_save()
vim.api.nvim_create_augroup("format_on_save_status", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorMovedI" }, {
    callback = function()
        require("trimclain.utils").update_autoformat_status()
    end,
    desc = "Update formatting status icon",
    group = "format_on_save_status",
})

-- Restore cursor position
vim.api.nvim_create_augroup("RestoreCursorPosition", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        -- TODO?: filetype/buftype exclude
        local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"')) -- when this is available, change unpack to table.unpack
        if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { row, col })
        end
    end,
    desc = "Return to last known cursor position",
    group = "RestoreCursorPosition",
})

-- Autocommands for QuickFixList
local quickfix_toggle = vim.api.nvim_create_augroup("quickfix_toggle", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "quickfix",
    callback = function()
        vim.g.qflist_global = 1
    end,
    desc = "Update quickfixlist status variable on open",
    group = quickfix_toggle,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    callback = function()
        vim.g.qflist_global = 0
    end,
    desc = "Update quickfixlist status variable on close",
    group = quickfix_toggle,
})

--- Replace nvim-tree's 'open_on_setup' option
---@param data
local function open_nvim_tree_or_fzf(data)
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not no_name and not directory then
        return
    end

    if directory then
        -- change to the directory
        vim.cmd.cd(data.file)
        -- open the tree
        require("nvim-tree.api").tree.open()
    end

    if no_name then
        require("telescope.builtin").find_files({hidden = true})
    end
end

vim.api.nvim_create_augroup("Nvim_Tree", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = open_nvim_tree_or_fzf,
    group = "Nvim_Tree",
})
