local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set(
    "n",
    "<leader>c",
    "<cmd>Neorg toggle-concealer<cr>",
    vim.tbl_extend("error", opts, { desc = "Toggle Neorg Concealer" })
)
