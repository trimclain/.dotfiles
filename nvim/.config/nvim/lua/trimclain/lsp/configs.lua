local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local servers = {
    "jsonls",
    "bashls",
    "cssls",
    "html",
    "pyright",
    "sumneko_lua",
    "tsserver",
    "vimls",
    "yamlls",
    "julials",
}

lsp_installer.setup {
    ensure_installed = servers,
    -- automatic_installation = false,
    ui = {
        icons = {
            -- server_installed = "◍",
            -- server_pending = "◍",
            -- server_uninstalled = "◍",
            -- server_installed = "✓",
            -- server_pending = "➜",
            -- server_uninstalled = "✗",
        },
        keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
        },
    },

    log_level = vim.log.levels.INFO,
    -- max_concurrent_installers = 4,
    -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
}

for _, server in pairs(servers) do
    local opts = {
        on_attach = require("trimclain.lsp.handlers").on_attach,
        capabilities = require("trimclain.lsp.handlers").capabilities,
    }
    local has_custom_opts, server_custom_opts = pcall(require, "trimclain.lsp.settings." .. server)
    if has_custom_opts then
        opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
    end
    lspconfig[server].setup(opts)
end
