-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("lua_highlight_yank", {
    clear = true,
})
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
local filetype_group = vim.api.nvim_create_augroup("filetype_group", {
    clear = true,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        -- "qf",
        "help",
        "lspinfo",
        "null-ls-info",
        "startuptime",
        "fugitive",
    },
    callback = function()
        vim.cmd [[
            nnoremap <silent> <buffer> q :close<CR>
            set nobuflisted
        ]]
    end,
    group = filetype_group,
})

-- TODO: add autosource the config file on save: WIP in functions
-- TODO: add a way to autoinstall lsp server when a new filetype is open (with some filtering of course)

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- local reload_packer = vim.api.nvim_create_augroup("packer_user_config", {
--     clear = true,
-- })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "plugins.lua",
--     command = "source <afile> | PackerSync",
--     group = reload_packer,
-- })

-- Autocmd for PackerSync on startup
-- local buf_enter_group = vim.api.nvim_create_augroup("packersync_on_startup", {
--     clear = true,
-- })
-- vim.api.nvim_create_autocmd("VimEnter", {
--     command = "PackerSync",
--     group = buf_enter_group,
-- })

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

local on_save_group = vim.api.nvim_create_augroup( -- create augroup
    "trimclain", -- set augroup name
    {
        clear = true, -- clear previous autocmds from this group (autocmd!)
    }
)
-- Autocommand to trim whitespaces
vim.api.nvim_create_autocmd(
    "BufWritePre", -- set the event for autocmd (:h events)
    {
        pattern = "*",
        command = "%s/\\s\\+$//e", -- pass a command or a function
        group = on_save_group, -- assign to the augroup
    }
)

-- Formatting
require("trimclain.functions").init_format_on_save()

local format_on_save_status = vim.api.nvim_create_augroup( -- create augroup
    "format_on_save_status", -- set augroup name
    {
        clear = true, -- clear previous autocmds from this group (autocmd!)
    }
)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        require("trimclain.functions").update_autoformat_status()
    end,
    group = format_on_save_status,
})
