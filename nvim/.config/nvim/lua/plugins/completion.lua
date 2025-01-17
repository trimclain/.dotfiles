if not CONFIG.plugins.use_blink_completion then
    return {}
end

-- My blink problems:
-- 1. Copilot integration doesn't work
-- 2. Snippets are a whole mess, need to figure them out if I wanna replace luasnip

return {
    {
        "saghen/blink.cmp",
        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = "cargo build --release",
        event = "VeryLazy", -- '/' and ':' autocomplete won't always work on InsertEnter
        dependencies = {
            "rafamadriz/friendly-snippets",
            -- "Kaiser-Yang/blink-cmp-dictionary"
            {
                "giuxtaposition/blink-cmp-copilot",
                enabled = CONFIG.lsp.enable_copilot and vim.fn.executable("node") == 1,
                cond = vim.g.neovide == nil,
                dependencies = "copilot.lua",
            },
        },

        -- Docs: https://cmp.saghen.dev/configuration/general.html
        opts = {
            keymap = {
                preset = "none",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-y>"] = { "select_and_accept" },
                -- cmdline forces to press enter twice to run a command and this is the problem
                ["<CR>"] = {
                    function(cmp)
                        if not cmp.is_visible() then
                            return
                        end

                        -- fallback for cmdtypes :@/?
                        if vim.api.nvim_get_mode().mode == "c" then
                            return
                        end

                        cmp.accept()
                        return true
                    end,
                    "fallback",
                },
                -- { "select_and_accept", "fallback" },

                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },

                -- snippets
                -- FIX: accept should only select_and_accept for snippet
                ["<C-k>"] = { "accept", "snippet_forward" },
                ["<C-j>"] = { "snippet_backward" },
                -- ["C-l"]
                -- ["C-h"]
            },
            completion = {
                keyword = {
                    -- "foo_|_bar" will match "foo_" for "prefix" and "foo__bar" for "full"
                    range = "full", -- default: "prefix"
                },
                accept = {
                    auto_brackets = { enabled = false },
                },
                list = {
                    -- per mode config: https://cmp.saghen.dev/recipes#change-selection-type-per-mode
                    selection = { preselect = false, auto_insert = true },
                    max_items = 10, -- defaul: 200
                },
                menu = {
                    -- Docs: https://cmp.saghen.dev/configuration/reference.html#completion-menu-draw
                    draw = {
                        align_to = "none", -- "label" (default), "none", "cursor"
                        -- treesitter = { "lsp" }, -- highlight the label text

                        -- Components to render, grouped by column
                        -- Options: "kind", "kind_icons", "label", "label_description", "source_name"
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "source_name" },
                        },
                        -- Definitions for possible components to render.
                        components = {
                            source_name = {
                                text = function(ctx)
                                    local custom_source_names = {
                                        copilot = "[copilot]",
                                        LSP = "[LSP]",
                                        -- latex_symbols = "[symb]",
                                        -- luasnip = "[snip]",
                                        Snippets = "[snip]",
                                        Path = "[path]",
                                        -- spell = "[spell]",
                                        Buffer = "[buf]",
                                        cmdline = "[cmd]",
                                    }
                                    return custom_source_names[ctx.source_name]
                                end,
                            },
                        },
                    },
                    border = CONFIG.ui.border,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200, -- default: 500
                    window = { border = CONFIG.ui.border },
                },
                -- ghost_text = {
                --     enabled = true,
                -- },
            },
            appearance = {
                -- TODO: remove after updating astrospeed
                use_nvim_cmp_as_default = true,
                kind_icons = require("core.icons").kinds,
            },
            sources = {
                default = { "lsp", "buffer", "path" },
                -- Docs: https://cmp.saghen.dev/configuration/reference.html#providers
                providers = {
                    buffer = {
                        min_keyword_length = 1,
                    },
                    cmdline = {
                        min_keyword_length = 2,
                    },
                    path = {
                        opts = {
                            trailing_slash = false,
                            label_trailing_slash = true,
                            -- PROBLEM: no option to show hidden only after I type .
                            -- show_hidden_files_by_default = true,
                        },
                    },
                    snippets = {
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
            snippets = { preset = "default" },
            -- Experimental signature help support
            -- signature = {
            --     enabled = true,
            --     window = { border = CONFIG.ui.border }
            -- },
        },
        config = function(_, opts)
            -- disable snippet completions inside comments and strings:
            local ts_ok, node = pcall(vim.treesitter.get_node)
            if
                ts_ok
                and node
                and not vim.tbl_contains({ "string", "comment", "line_comment", "block_comment" }, node:type())
            then
                table.insert(opts.sources.default, "snippets")
            end

            -- setup lazydev
            if require("core.util").has_plugin("lazydev") then
                table.insert(opts.sources.default, 1, "lazydev")
                opts.sources.providers.lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100, -- show at a higher priority than lsp
                }
            end

            -- setup copilot cmp source
            if require("core.util").has_plugin("copilot") then
                table.insert(opts.sources.default, 1, "copilot")
                opts.sources.providers.copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 101, -- show at a higher priority than lsp
                    async = true,
                }
            end

            require("blink.cmp").setup(opts)
        end,
    },

    -- enable type checking to develop neovim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                -- Only load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                --{ path = "LazyVim", words = { "LazyVim" } },
                --{ path = "snacks.nvim", words = { "Snacks" } },
                --{ path = "lazy.nvim", words = { "LazyVim" } },
                -- -- Load the wezterm types when the `wezterm` module is required
                -- -- Needs `justinsgithub/wezterm-types` to be installed
                --{ path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },

    -- catppuccin support
    {
        "catppuccin",
        optional = true,
        opts = {
            integrations = { blink_cmp = true },
        },
    },

    -- github copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        enabled = CONFIG.lsp.enable_copilot and vim.fn.executable("node") == 1,
        cond = vim.g.neovide == nil,
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },
}
