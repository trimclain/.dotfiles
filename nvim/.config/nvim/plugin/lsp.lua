-- ############################################################################
-- Lsp Options and Remaps
-- ############################################################################

-- LSP autocomplete
vim.opt.completeopt = {"menu", "menuone", "noselect"} -- required by nvim-cmp
vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}

-- Used
vim.keymap.set("n", "<leader>vd", vim.lsp.buf.definition, {buffer=0})
vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {buffer=0})
vim.keymap.set("n", "<leader>vff", vim.lsp.buf.formatting, {buffer=0})
vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover, {buffer=0})
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {buffer=0})
