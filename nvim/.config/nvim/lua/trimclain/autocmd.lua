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

-- Autocommand which call my function TrimWhitespace
-- Example: how to write autocommands in lua
local group = vim.api.nvim_create_augroup( -- create augroup
    "trimclain", -- set augroup name
    {
        clear = true,    -- clear previous autocmds from this group (autocmd!)
    }
)
vim.api.nvim_create_autocmd(
    "BufWritePre", -- set the event for autocmd (:h events)
    {
        callback = "TrimWhitespace", -- pass the function
        group = group, -- assign to the augroup
    }
)

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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- local reload_packer = vim.api.nvim_create_augroup("packer_user_config", {
--     clear = true,
-- })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "plugins.lua",
--     command = "source <afile> | PackerSync",
--     group = reload_packer,
-- })
