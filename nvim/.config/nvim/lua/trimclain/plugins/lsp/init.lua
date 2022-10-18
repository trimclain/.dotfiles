local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- Lsp Options
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

require "trimclain.plugins.lsp.lsp-signature"
require "trimclain.plugins.lsp.mason"
require("trimclain.plugins.lsp.handlers").setup()
require "trimclain.plugins.lsp.null-ls"
