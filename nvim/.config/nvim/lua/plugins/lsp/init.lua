local Util = require("core.util")

return {
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", opts = {} }, -- enable type checking to develop neovim
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                cond = function()
                    return Util.has_plugin("nvim-cmp")
                end,
            },
            {
                "smjonas/inc-rename.nvim",
                opts = { preview_empty_name = false },
                config = function(_, opts)
                    require("inc_rename").setup(opts)
                end,
            },
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = CONFIG.lsp.virtual_text and { spacing = 4, source = "if_many", prefix = "●" } or false,
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
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = false,
            },
            -- add any global capabilities here
            capabilities = {},
            -- TODO:
            -- Automatically format on save
            -- autoformat = CONFIG.lsp.format_on_save,

            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the formatter,
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
                -- pyright = {}, -- breaks nvim on quit, have to kill it (2023-06-17)
                jedi_language_server = {},
                html = {},
                cssls = {},
                emmet_ls = {},
                -- tailwindcss = {},
                tsserver = {},
                volar = {}, -- vue-language-server
                bashls = {},
                marksman = {}, -- markdown
                vimls = {},
                -- yamlls = {},
                -- texlab = {}, -- latex
                graphql = {},
                -- julials = {}, -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/julials/README.md
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
            -- require("plugins.lsp.format").autoformat = opts.autoformat

            -- setup formatting and keymaps
            Util.on_attach(function(client, buffer)
                -- TODO: this is the autoformat
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
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

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
        "nvimtools/none-ls.nvim",
        -- TODO: someday
        -- Use these replacement plugins:
        -- "stevearc/conform.nvim" -- for formatters
        -- "mfussenegger/nvim-lint" -- for linters
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
                        disabled_filetypes = { "markdown" },
                    }),
                    -- nls.builtins.formatting.ruff.with({ -- an extremely fast python formatter/linter, written in rust
                    --     extra_args = { "--ignore", "E501" }, -- ignore long lines
                    -- }),
                    nls.builtins.formatting.autopep8,
                    nls.builtins.formatting.beautysh,
                    nls.builtins.formatting.isort,
                    nls.builtins.formatting.stylua,

                    -- Linters
                    nls.builtins.diagnostics.ruff.with({
                        extra_args = { "--ignore", "E501" }, -- ignore long lines
                    }),
                    -- nls.builtins.diagnostics.selene,
                    nls.builtins.diagnostics.shellcheck,
                    -- nls.builtins.diagnostics.eslint_d, -- Once spawned, the server will continue to run in the background.
                    -- This is normal and not related to null-ls.
                    -- You can stop it by running eslint_d stop from the command line.

                    -- Hover
                    nls.builtins.hover.printenv.with({ -- shows the value for the current environment variable under the cursor
                        filetypes = { "zsh", "sh", "dosbatch", "ps1" },
                    }),
                    -- nls.builtins.hover.dictionary.with({ -- shows the first available definition for the current word under the cursor
                    --     filetypes = { "org", "text", "markdown" },
                    -- }),
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
            ui = {
                icons = {
                    package_installed = "✓",
                    package_uninstalled = "✗",
                    package_pending = "⟳",
                },
                border = CONFIG.ui.border,
            },
            ensure_installed = {
                -- Formatters
                "autopep8",
                "beautysh",
                "isort",
                "prettierd",
                "stylua",

                -- Linters
                "eslint_d",
                "ruff",
                -- "selene",
                "shellcheck",
                "stylelint", -- css linter
            },
        },
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
