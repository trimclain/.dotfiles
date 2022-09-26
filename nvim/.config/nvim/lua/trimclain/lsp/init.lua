local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- Lsp Options
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

require "trimclain.lsp.lsp-signature"
require "trimclain.lsp.mason"
require("trimclain.lsp.handlers").setup()
require "trimclain.lsp.null-ls"
