local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
    return
end
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
    local icons = require "trimclain.icons"
    local signs = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- If I'm tired of lsp telling me I'm wrong and want to use `gl` only, come here and make both false
        -- enable/disable virtual text (errors on the right)
        -- virtual_lines = false,
        virtual_text = true,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always", -- or "if_many"
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gl",
        '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
        opts
    )
end

-- for nvim-navic
-- to fix the error of connecting to multiple servers on a buffer I add my own global variable
-- vim.g.navic_is_attached = false

-- local function attach_navic(client, bufnr)
--     vim.g.navic_silence = false
--     local navic_status_ok, navic = pcall(require, "nvim-navic")
--     if not navic_status_ok then
--         return
--     end
--     if client.server_capabilities.documentSymbolProvider and not vim.g.navic_is_attached then
--         navic.attach(client, bufnr)
--         vim.g.navic_is_attached = true
--     end
-- end

M.on_attach = function(client, bufnr)
    -- TODO: there is a better way at https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
    -- to disable popus to choose the server when using formatting, add it here
    if client.name == "tsserver" or client.name == "sumneko_lua" then
        -- client.server_capabilities.document_formatting = false -- 0.7 and earlier
        client.server_capabilities.documentFormattingProvider = false -- 0.8 and hopefully later
        -- require("lsp-inlayhints").on_attach(client, bufnr)
    end
    lsp_keymaps(bufnr)
    -- attach_navic(client, bufnr) -- for nvim-navic
end

return M
