-- TODO: setup ensure_installed for both servers and formatters/linters
return {
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                cond = function()
                    return require("core.util").has_plugin("nvim-cmp")
                end,
            },
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = CONFIG.lsp.virtual_text,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = CONFIG.ui.border,
                    source = "always", -- or "if_many"
                    header = "",
                    prefix = "",
                },
            },
            -- Automatically format on save
            -- autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            -- Servers listed here will be autoinstalled
            ---@type lspconfig.options
            servers = {
                -- Available servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
                pyright = {},
                html = {},
                cssls = {},
                emmet_ls = {},
                -- tailwindcss = {},
                tsserver = {},
                volar = {}, -- vue-language-server
                bashls = {},
                vimls = {},
                yamlls = {},
                graphql = {},
                -- julials = {},
                -- ansiblels = {},
                dockerls = {},

                jsonls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- TODO:
            -- setup autoformat
            -- require("lazyvim.plugins.lsp.format").autoformat = opts.autoformat
            -- setup formatting and keymaps
            require("core.util").on_attach(function(client, buffer)
                -- require("plugins.lsp.format").on_attach(client, buffer)
                require("plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- Make the borders rounded
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = CONFIG.ui.border,
            })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = CONFIG.ui.border,
            })

            -- diagnostics
            for name, icon in pairs(require("core.icons").diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities =
                require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available thourgh mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed })
                mlsp.setup_handlers({ setup })
            end
        end,
    },

    -- Formatters and Linters
    -- Sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- Sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function()
            local nls = require("null-ls")
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    -- Formatters
                    nls.builtins.formatting.prettierd.with({
                        extra_args = { "--tab-width=4" }, -- , "--jsx-single-quote", "--no-semi", "--single-quote",
                        extra_filetypes = { "toml" },
                    }),
                    nls.builtins.formatting.black.with({
                        extra_args = {
                            "--fast", -- if --fast given, skip temporary sanity checks [default: --safe]
                            -- "--skip-string-normalization", -- don't normalize string quotes (don't change single to double) or prefixes
                        },
                    }),
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.beautysh,

                    -- Linters
                    nls.builtins.diagnostics.flake8,
                    nls.builtins.diagnostics.shellcheck,
                    nls.builtins.diagnostics.eslint_d, -- Once spawned, the server will continue to run in the background.
                    -- This is normal and not related to null-ls.
                    -- You can stop it by running eslint_d stop from the command line.
                },
            }
        end,
    },

    -- cmdline tools and lsp servers
    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            -- Formatters and Linters
            ensure_installed = {
                "stylua",
                "prettierd",
                "black",
                "beautysh",
                "flake8",
                "shellcheck",
                "eslint_d",
            },
            border = CONFIG.ui.border,
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
}
