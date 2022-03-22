-- This file is meant to overwrite some default settings for this filetype.
-- It gets sourced everytime I open a file of this type.

-- vim.bo.textwidth = 120

-- vim.bo.shiftwidth = 2

-- TODO: how do you do [setlocal formatoptions-=0], coz now it's global
vim.opt.formatoptions:remove("o")
