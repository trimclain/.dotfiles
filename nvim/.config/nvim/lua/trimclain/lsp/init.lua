-- Lsp Options
vim.opt.completeopt = {"menu", "menuone", "noselect"} -- required by nvim-cmp
vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("trimclain.lsp.lsp-installer")
require("trimclain.lsp.handlers").setup()
