vim.opt_local.colorcolumn = "100"

-- set a break point for undo after Space
vim.keymap.set("i", "<Space>", "<Space><C-g>u", { noremap = true, silent = true })
