-- This file is meant to overwrite some default settings for this filetype.
-- It gets sourced everytime I open a file of this type.

-- vim.bo.textwidth = 120

-- vim.bo.shiftwidth = 2

vim.opt.formatoptions = vim.opt.formatoptions - "o"


local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- run a python3 file
keymap("n", "<C-b>", ":w <bar> :! python3 %<cr>", opts)
