-- This file is meant to overwrite some default settings for this filetype.
-- It gets sourced everytime I open a file of this type.
--
-- " setlocal textwidth=120
--
-- " setlocal shiftwidth=2
--
-- " setlocal formatoptions-=o

-- set vertical line to see 100 characters locally
vim.wo.colorcolumn = "100" -- vim.wo and not vim.wo coz colorcolumn is a window option

local opts = { noremap = true, silent = true }

local remap = function()
     vim.keymap.set("i", "<cr>", "<cr>- [ ] ", opts)
end

vim.keymap.set("n", "<leader>td", remap, opts)
