-- TODO: refactor into other files
local Util = require("core.util")
local Icons = require("core.icons")

return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        -- TODO: do I need this for neovide? (bashls errors, but pylsp doesn't)
        -- cond = vim.fn.executable("node"),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
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
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("trimclain_lsp_attach", { clear = true }),
                callback = function(event)
                    -- adjust the border for LSP floating windows
                    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                        border = CONFIG.ui.border,
                    })
                    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                        border = CONFIG.ui.border,
                    })

                    -- configure diagnostics
                    for name, icon in pairs(Icons.diagnostics) do
                        name = "DiagnosticSign" .. name
                        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
                    end
                    vim.diagnostic.config({
                        underline = true,
                        update_in_insert = false,
                        virtual_text = CONFIG.lsp.virtual_text and { spacing = 4, source = "if_many", prefix = "●" }
                            or false,
                        severity_sort = true,
                        float = {
                            focusable = false,
                            style = "minimal",
                            border = CONFIG.ui.border,
                            source = "if_many",
                            header = "",
                            prefix = "",
                        },
                    })

                    -----------------------------------------------------------
                    -- Keymaps
                    -----------------------------------------------------------
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("<leader>li", "<cmd>LspInfo<cr>", "[L]sp [I]nfo")
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gl", vim.diagnostic.open_float, "[G]et [L]ine Diagnostics")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gK", vim.lsp.buf.signature_help, "Signature Help")
                    map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document [S]ymbols")

                    -- Diagnostic keymaps
                    local function diagnostic_goto(next, severity)
                        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
                        severity = severity and vim.diagnostic.severity[severity] or nil
                        return function()
                            go({ severity = severity })
                        end
                    end
                    map("[d", diagnostic_goto(false), "Previous [D]iagnostic")
                    map("]d", diagnostic_goto(true), "Next [D]iagnostic")
                    map("]e", diagnostic_goto(true, "ERROR"), "Next [E]rror")
                    map("[e", diagnostic_goto(false, "ERROR"), "Previous [E]rror")
                    map("]w", diagnostic_goto(true, "WARN"), "Next [W]arning")
                    map("[w", diagnostic_goto(false, "WARN"), "Previous [W]arning")

                    if Util.has_plugin("inc-rename.nvim") then
                        vim.keymap.set("n", "<leader>lr", function()
                            return ":IncRename " .. vim.fn.expand("<cword>")
                        end, { buffer = event.buf, desc = "LSP: [R]ename", expr = true })
                    else
                        map("<leader>lr", vim.lsp.buf.rename, "[R]ename")
                    end

                    vim.keymap.set(
                        { "n", "v" },
                        "<leader>la",
                        vim.lsp.buf.code_action,
                        { buffer = event.buf, desc = "LSP: Code [A]ction" }
                    )
                    map("<leader>lA", function()
                        vim.lsp.buf.code_action({
                            context = {
                                only = {
                                    "source",
                                },
                                diagnostics = {},
                            },
                        })
                    end, "Source [A]ction")

                    -- Inlay Hints
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        if CONFIG.ui.inlay_hints then
                            vim.lsp.inlay_hint.enable()
                        end
                        map("<leader>oh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "Toggle Inlay [H]ints")
                    end
                end,
            })
        end,
    },

    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        cmd = "Mason",
        keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "[M]ason" } },
        opts = {
            ui = {
                icons = {
                    package_installed = Icons.ui.UnicodeCheck,
                    package_uninstalled = Icons.ui.UnicodeBallotX,
                    package_pending = Icons.ui.UnicodeCircleArrow,
                },
                border = CONFIG.ui.border,
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local has_blink, blink = pcall(require, "blink.cmp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {},
                opts.capabilities or {}
            )

            -- LSP Server Settings
            -- Servers listed here will be autoinstalled
            local servers = {
                -- Available servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
                pylsp = {
                    settings = {
                        -- docs: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
                        pylsp = {
                            -- configurationSources = { "flake8" }, -- (one of: 'pycodestyle', 'flake8')
                            plugins = {
                                pycodestyle = {
                                    ignore = { "E501" }, -- ignore long lines
                                },
                                yapf = { enabled = false },
                                -- autopep8 = { enabled = false },
                                -- mccabe = { enabled = false },
                                -- preload = { enabled = false },
                                -- pycodestyle = { enabled = false },
                                -- pyflakes = { enabled = false },

                                -- flake8 = { enabled = true },
                                -- pydocstyle = { enabled = true },
                                -- pylint = { enabled = true },
                                -- rope_autoimport = { enabled = true },
                            },
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
                ts_ls = {}, -- Extended: https://github.com/pmizio/typescript-tools.nvim
                volar = {}, -- vue-language-server
                graphql = {},
                jsonls = {},

                -- yamlls = {},
                -- texlab = {}, -- latex
                -- julials = {}, -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/julials/README.md
                -- ansiblels = {},
                vimls = {},
                lua_ls = {
                    -- cmd = {...}, -- Override the default command used to start the server
                    -- filetypes = { ...}, -- Override the default list of associated filetypes for the server
                    -- capabilities = {}, -- Override fields in capabilities. Can be used to disable certain LSP features.
                    settings = { -- Override the default settings passed when initializing the server.
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
                                -- ignore Lua_LS's noisy `missing-fields` warnings
                                -- disable = { 'missing-fields' },
                            },
                            hint = {
                                enable = true,
                                setType = true,
                                -- semicolon = "Disable" -- default: "SameLine"
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                        },
                    },
                },
            }

            local formatters_and_linters = {
                -- Formatters
                "isort",
                "autopep8",
                "prettierd",
                "stylua",
                "shfmt", -- "beautysh",
                "gofumpt",

                -- Linters
                -- "eslint_d", -- need config file, annoying
                -- "luacheck", -- "selene",
                -- "markdownlint",
                -- "stylelint", -- css linter
                "shellcheck", -- extends bashls
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, formatters_and_linters)
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        enabled = false, -- I don't use any linters right now
        opts = {
            -- Event to trigger linters
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                -- markdown = { "markdownlint" }, -- { "vale" }
                -- dockerfile = { "hadolint" },
                -- json = { "jsonlint" },
                -- Use the "*" filetype to run linters on all filetypes.
                -- ['*'] = { 'global linter' },
                -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                -- ['_'] = { 'fallback linter' },
                -- ["*"] = { "typos" },
            },
            linters = {
                -- use selene only when a selene.toml file is present
                -- selene = {
                --     -- dynamically enable/disable linters based on the context.
                --     condition = function(ctx)
                --         return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
                --     end,
                -- },
            },
        },
        config = function(_, opts)
            local M = {}

            local lint = require("lint")
            for name, linter in pairs(opts.linters) do
                if type(linter) == "table" and type(lint.linters[name]) == "table" then
                    lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
                else
                    lint.linters[name] = linter
                end
            end
            lint.linters_by_ft = opts.linters_by_ft

            function M.debounce(ms, fn)
                local timer = vim.uv.new_timer()
                return function(...)
                    local argv = { ... }
                    ---@diagnostic disable-next-line: need-check-nil
                    timer:start(ms, 0, function()
                        ---@diagnostic disable-next-line: need-check-nil
                        timer:stop()
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            -- Credit: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/linting.lua
            function M.lint()
                -- Use nvim-lint's logic first:
                -- * checks if linters exist for the full filetype first
                -- * otherwise will split filetype by "." and add all those linters
                -- * this differs from conform.nvim which only uses the first filetype that has a formatter
                local names = lint._resolve_linter_by_ft(vim.bo.filetype)

                -- Create a copy of the names table to avoid modifying the original.
                names = vim.list_extend({}, names)

                -- Add fallback linters.
                if #names == 0 then
                    vim.list_extend(names, lint.linters_by_ft["_"] or {})
                end

                -- Add global linters.
                vim.list_extend(names, lint.linters_by_ft["*"] or {})

                -- Filter out linters that don't exist or don't match the condition.
                local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
                names = vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    if not linter then
                        vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "Nvim Lint" })
                    end
                    return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
                end, names)

                -- Run linters.
                if #names > 0 then
                    lint.try_lint(names)
                end
            end

            vim.api.nvim_create_autocmd(opts.events, {
                group = vim.api.nvim_create_augroup("trimclain_lint", { clear = true }),
                callback = M.debounce(100, M.lint),
            })
        end,
    },
}
