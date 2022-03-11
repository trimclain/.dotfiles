-- #############################################################################
-- Telescope Configs and Remaps
-- #############################################################################

vim.keymap.set("n", "<leader>ps", ":lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>")
-- TODO: what is this next line
-- vim.keymap.set("n", "<leader>pw", ":lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>")
-- vim.keymap.set("n", "<leader>ps", ":lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>")

vim.keymap.set("n", "<leader>gh", ":lua require('telescope.builtin').help_tags()<CR>")
vim.keymap.set("n", "<leader>gk", ":lua require('telescope.builtin').keymaps()<CR>")
vim.keymap.set("n", "<leader>gl", ":lua require('telescope.builtin').git_commits()<CR>")
vim.keymap.set("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>")

vim.keymap.set("n", "<leader>pf", ":Telescope find_files <cr>")
vim.keymap.set("n", "<leader>phf", ":Telescope find_files hidden=true <cr>")
vim.keymap.set("n", "<leader>pb", ":Telescope buffers <cr>")

vim.keymap.set("n", "<leader>vrc", ":Telescope git_files cwd=~/.dotfiles <cr>")
vim.keymap.set("n", "<leader>f;", ":Telescope commands <cr>")
