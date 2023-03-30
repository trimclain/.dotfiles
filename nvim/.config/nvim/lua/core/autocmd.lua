local function augroup(name)
    return vim.api.nvim_create_augroup("trimclain" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    command = "checktime",
    desc = "Check if we need to reload the file when it changed",
    group = augroup("checktime"),
})

-- Highlight on yank
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
    group = augroup("highlight_on_yank"),
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Resize splits if window got resized",
    group = augroup("resize_splits"),
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        -- TODO?: filetype/buftype exclude
        local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"')) -- when this is available, change unpack to table.unpack
        if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { row, col })
        end
    end,
    desc = "Return to last known cursor position",
    group = augroup("restore_cursor_position"),
})

-- Trim whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
    command = "%s/\\s\\+$//e",
    desc = "Delete useless whitespaces when saving the file",
    group = augroup("trim_whitespace_on_save"),
})

-- Fix formatoptions since they get overwritten (see options.lua:65)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt_local.formatoptions:remove "o"
    end,
    desc = "Fix formatoptions",
    group = augroup("fix_formatoptions"),
})

-- TODO: fix the pattern list
-- Close these filetypes with a single keypress instead of :q
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf", -- QuickFixList
        "help", -- nvim help
        "man", -- nvim man pages
        "startuptime", -- dstein64/vim-startuptime
        "spectre_panel", -- nvim-pack/nvim-spectre
        -- "Jaq",
        -- "null-ls-info",
        -- "notify",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Set these filetypes to close with q-press and to not be in the buffers list",
    group = augroup("close_with_q"),
})

-- TODO: do I want this?
-- Enable spell in following filetypes
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "markdown", "NeogitCommitMessage" },
--     callback = function()
--         vim.opt_local.spell = true
--     end,
--     desc = "Enable builin spellcheck in following filetypes",
--     group = filetype_group,
-- })

-------------------------------------------------------------------------------

-- TODO: ?
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

-- TODO: do I still use this?
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

--TODO: set this up for neotree
--- Replace nvim-tree's 'open_on_setup' option
---@param data
-- local function open_nvim_tree_or_fzf(data)
--     -- buffer is a [No Name]
--     local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
--
--     -- buffer is a directory
--     local directory = vim.fn.isdirectory(data.file) == 1
--
--     if not no_name and not directory then
--         return
--     end
--
--     if directory then
--         -- change to the directory
--         vim.cmd.cd(data.file)
--         -- open the tree
--         require("nvim-tree.api").tree.open()
--     end
--
--     if no_name then
--         require("telescope.builtin").find_files({hidden = true})
--     end
-- end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--     callback = open_nvim_tree_or_fzf,
--     group = augroup("Nvim_Tree"),
-- })