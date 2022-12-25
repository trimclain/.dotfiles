vim.opt_local.colorcolumn = "100"
vim.opt_local.textwidth = 100

local opts = { noremap = true, silent = true }

-- set a break point for undo after Space
vim.keymap.set("i", "<space>", "<space><c-g>u", opts)

vim.keymap.set("n", "<leader>md", "<cmd>setlocal spelllang=de<cr>", opts)
vim.keymap.set("n", "<leader>me", "<cmd>setlocal spelllang=en<cr>", opts)
vim.keymap.set("i", "--", "—", { noremap = true })
