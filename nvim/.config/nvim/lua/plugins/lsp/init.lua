local Util = require("core.util")

return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", opts = {} }, -- enable type checking to develop neovim
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                cond = Util.has_plugin("nvim-cmp"),
            },
            {
                "smjonas/inc-rename.nvim",
                opts = { preview_empty_name = false },
                config = function(_, opts)
                    require("inc_rename").setup(opts)
                end,
            },
        },
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
            servers = {
                -- Available servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
                -- pyright = {}, -- slow startup
                ruff_lsp = {
                    init_options = {
                        settings = {
                            args = { "--ignore", "E501" }, -- ignore long lines
                        },
                    },
                },
                bashls = {},
                marksman = {}, -- markdown
                dockerls = {},

                html = {},
                cssls = {},
                emmet_ls = {},
                -- tailwindcss = {},
                tsserver = {},
                volar = {}, -- vue-language-server
                graphql = {},
                jsonls = {},

                -- yamlls = {},
                -- texlab = {}, -- latex
                -- julials = {}, -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/julials/README.md
                -- ansiblels = {},
                vimls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        -- docs: https://luals.github.io/wiki/settings/
                        Lua = {
                            completion = {
                                -- "Disable" - Only show function name (default)
                                -- "Both" - Show function name and snippet
                                -- "Replace" - Only show the call snippet
                                callSnippet = "Replace",
                            },
                            diagnostics = {
                                globals = { "describe", "it", "before_each", "after_each", "vim" },
                            },
                            hint = {
                                enable = true,
                                setType = true,
                                -- semicolon = "Disable" -- default: "SameLine"
                            },
                            workspace = {
                                checkThirdParty = false,
                                -- TODO:?
                                -- library = {
                                --     vim.fn.expand("$VIMRUNTIME"),
                                --     require("neodev.config").types(),
                                --     "${3rd}/busted/library",
                                --     "${3rd}/luassert/library",
                                --     "${3rd}/luv/library",
                                -- },
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
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

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {}
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

    -- TODO:
    -- {
    --     "stevearc/conform.nvim",
    --     opts = {
    --         -- notify_on_error = false,
    --         -- format_on_save = {
    --         --     timeout_ms = 500,
    --         --     lsp_fallback = true,
    --         -- },
    --         formatters_by_ft = {
    --             lua = { "stylua" },
    --             sh = { "shfmt" }, -- beautysh
    --             -- Conform can also run multiple formatters sequentially
    --             python = { "isort", "autopep8" }, -- ruff
    --             --
    --             -- You can use a sub-list to tell conform to run *until* a formatter
    --             -- is found.
    --             javascript = { { "prettierd", "prettier" } },
    --         },
    --     },
    -- },

    -- TODO:
    -- "mfussenegger/nvim-lint" -- for linters
    -- https://github.com/LazyVim/LazyVim/blob/e5babf289c5ccd91bcd068bfc623335eb76cbc1f/lua/lazyvim/plugins/linting.lua

    -- Formatters and Linters
    -- Sources: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- Sources: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            -- "gbprod/none-ls-luacheck.nvim",
        },
        opts = function()
            local nls = require("null-ls")

            -- nls.register(require("none-ls-luacheck.diagnostics.luacheck"))
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    -- Formatters
                    nls.builtins.formatting.prettierd.with({
                        extra_args = { "--tab-width=4" }, -- , "--jsx-single-quote", "--no-semi", "--single-quote",
                        extra_filetypes = { "toml" },
                        disabled_filetypes = { "markdown" },
                    }),
                    nls.builtins.formatting.isort,
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.shfmt, -- switched from beautysh
                    nls.builtins.formatting.gofumpt,

                    -- Linters
                    -- TODO: replace with eslint-language-server
                    -- nls.builtins.diagnostics.eslint_d,

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
                -- "autopep8",
                "isort",
                "prettierd",
                "stylua",
                "shfmt", -- "beautysh",
                "gofumpt",

                -- Linters
                -- "eslint_d", -- need config file, annoying
                -- "luacheck", -- "selene",
                "shellcheck", -- extends bashls
                -- "stylelint", -- css linter
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
