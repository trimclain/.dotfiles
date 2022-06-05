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

-- Example: how to write autocommands in lua
local on_save_group = vim.api.nvim_create_augroup( -- create augroup
    "trimclain", -- set augroup name
    {
        clear = true, -- clear previous autocmds from this group (autocmd!)
    }
)
-- Autocommand which call my function TrimWhitespace
vim.api.nvim_create_autocmd(
    "BufWritePre", -- set the event for autocmd (:h events)
    {
        callback = "TrimWhitespace", -- pass the function
        group = on_save_group, -- assign to the augroup
    }
)
-- Autocmd for lsp formatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.ts", "*.jsx", "*.lua" },
    -- TODO: formatting_sync is deprecated
    callback = vim.lsp.buf.formatting_sync,
    group = on_save_group,
})

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

local filetype_group = vim.api.nvim_create_augroup("filetype_group", {
    clear = true,
})
-- Close these filetypes with a single keypress instead of :q
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { --[[ "qf", ]]
        "help",
        "lspinfo",
        "null-ls-info",
    },
    callback = function()
        vim.cmd [[
            nnoremap <silent> <buffer> q :close<CR>
            set nobuflisted
        ]]
    end,
    group = filetype_group,
})

-- Enable winbar
local winbar_group = vim.api.nvim_create_augroup("winbar_group", {
    clear = true,
})
vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost" }, {
    callback = function()
        require("trimclain.winbar").get_winbar()
    end,
    group = winbar_group,
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
