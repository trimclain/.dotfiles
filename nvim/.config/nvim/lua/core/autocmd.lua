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
        vim.highlight.on_yank({
            -- higroup = "IncSearch",
            -- higroup = "Substitute",
            -- higroup = "Search",
            higroup = "Visual",
            timeout = 75,
            on_macro = true,
            on_visual = true,
            priority = 250,
        })
    end,
    desc = "Highlight text on yank",
    group = augroup("highlight_on_yank"),
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
    command = "quit",
    desc = "Autoclose command-line window",
    group = augroup("autoclose_commandline_window"),
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    command = "tabdo wincmd =",
    desc = "Resize splits if window got resized",
    group = augroup("resize_splits"),
})

-- Fix a bug with cmdheight on vim resize TODO: remove this when it's fixed
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        local old_cmdheight = vim.o.cmdheight
        if  old_cmdheight > 1 then
            vim.notify("Resizing cmdheight from " .. old_cmdheight, vim.log.levels.INFO, { title = "Thank You Neovim" })
            vim.o.cmdheight = 1
        end
    end,
    desc = "Fix nvim bug with cmdheight on vim resize",
    group = augroup("fix_nvim_bug_with_cmdheight"),
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event)
        unpack = unpack or table.unpack
        local row, col = unpack(vim.api.nvim_buf_get_mark(event.buf, '"')) -- when this is available, change unpack to table.unpack
        if row > 0 and row <= vim.api.nvim_buf_line_count(event.buf) then
            vim.api.nvim_win_set_cursor(0, { row, col })
            vim.cmd.normal("zz")
        end
    end,
    desc = "Return to last known cursor position",
    group = augroup("restore_cursor_position"),
})

-- Trim whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
    command = [[%s/\s\+$//e]],
    desc = "Delete useless whitespaces when saving the file",
    group = augroup("trim_whitespace_on_save"),
})

-- Fix formatoptions since they get overwritten (see options.lua:65)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
    desc = "Fix formatoptions",
    group = augroup("fix_formatoptions"),
})

-- Close these filetypes with a single keypress instead of :q
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf", -- QuickFixList
        "help", -- nvim help
        "man", -- nvim man pages
        "startuptime", -- dstein64/vim-startuptime
        "spectre_panel", -- nvim-pack/nvim-spectre
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Set these filetypes to close with q-press and to not be in the buffers list",
    group = augroup("close_with_q"),
})

-- Enable spell and wrap in following filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown", "NeogitCommitMessage" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
    desc = "Enable word wrap and spellcheck in markdown and gitcommit filetypes",
    group = augroup("enable_spell_wrap"),
})

-- Hide cursorline in insert mode
if CONFIG.ui.cursorline then
    local cursorline_toggle = augroup("cursorline_toggle")
    vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
        pattern = "*",
        command = "set cursorline",
        desc = "Enable cursorline in normal mode",
        group = cursorline_toggle,
    })
    vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
        pattern = "*",
        command = "set nocursorline",
        desc = "Disable cursorline in insert mode",
        group = cursorline_toggle,
    })
end

-----------------------------------------------------------------------------------------------------------------------
-- Filetypes
-----------------------------------------------------------------------------------------------------------------------

vim.filetype.add({
    extension = {
        anki = "anki",
    },
    filename = {
        ["ankitemp"] = "anki",
    },
})
