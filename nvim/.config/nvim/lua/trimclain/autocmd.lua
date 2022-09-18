-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("lua_highlight_yank", {
    clear = true,
})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            -- higroup = "hl-IncSearch",
            higroup = "Substitute",
            timeout = 150,
            on_macro = true,
            on_visual = true,
        }
    end,
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

    " Delete useless spaces
    fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfun
]]

local on_save_group = vim.api.nvim_create_augroup( -- create augroup
    "trimclain", -- set augroup name
    {
        clear = true, -- clear previous autocmds from this group (autocmd!)
    }
)
-- Autocommand which calls my function TrimWhitespace
vim.api.nvim_create_autocmd(
    "BufWritePre", -- set the event for autocmd (:h events)
    {
        callback = "TrimWhitespace", -- pass the function
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
