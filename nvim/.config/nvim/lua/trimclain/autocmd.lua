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
        -- "qf",
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

-- TODO: What's the problem here?
-- Autocommand to source every config file I save
-- local source_config = vim.api.nvim_create_augroup("source_config_on_save", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = require("trimclain.utils").get_list_of_config_files(),
--     command = "source <afile>",
--     desc = "Source config files on save",
--     group = source_config,
-- })

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local reload_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "plugins.lua",
    command = "source <afile> | PackerSync",
    desc = "Run PackerSync after saving plugins.lua",
    group = reload_packer,
})

-- Autocmd for PackerSync everyday
vim.api.nvim_create_augroup("packersync_on_startup", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("trimclain.utils").update_plugins_every_day()
    end,
    desc = "Daily update plugins on startup",
    group = "packersync_on_startup",
})

-- Autocommand to trim whitespaces
vim.api.nvim_create_augroup("TrimWhitespacesOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e",
    desc = "Delete useless whitespaces when saving the file",
    group = "TrimWhitespacesOnSave",
})

-- Formatting
require("trimclain.utils").init_format_on_save()
vim.api.nvim_create_augroup("format_on_save_status", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        require("trimclain.utils").update_autoformat_status()
    end,
    desc = "Enable AutoFormatting",
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
