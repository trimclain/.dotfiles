return {
    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "VeryLazy", -- '/' and ':' autocomplete won't always work on InsertEnter
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            "kdheepak/cmp-latex-symbols",

            -- "lukas-reineke/cmp-rg" -- source for using ripgrep
            -- "ray-x/cmp-treesitter" -- source for treesitter nodes
            -- "lukas-reineke/cmp-under-comparator" -- better sort completion items that start with underlines
            -- "amarakon/nvim-cmp-fonts" -- source for fonts using fontconfig
            -- "jcha0713/cmp-tw2css" -- source to convert tailwindcss classes to pure css

            {
                "hrsh7th/cmp-nvim-lsp-signature-help",
                enabled = CONFIG.lsp.show_signature_help,
            },
            {
                "zbirenbaum/copilot-cmp",
                enabled = CONFIG.lsp.enable_copilot and vim.fn.executable("node") == 1,
                cond = vim.g.neovide == nil,
                dependencies = "copilot.lua",
                opts = {},
                config = function(_, opts)
                    local copilot_cmp = require("copilot_cmp")
                    copilot_cmp.setup(opts)
                    -- attach cmp source whenever copilot attaches
                    -- fixes lazy-loading issues with the copilot cmp source
                    vim.api.nvim_create_autocmd("LspAttach", {
                        group = vim.api.nvim_create_augroup("trimclain_copilot_lsp_attach", { clear = true }),
                        callback = function(args)
                            local client = vim.lsp.get_client_by_id(args.data.client_id)
                            if client.name == "copilot" then
                                copilot_cmp._on_insert_enter({})
                            end
                        end,
                    })
                end,
            },
        },
        config = function()
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local opts = {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = CONFIG.ui.border == "rounded" and {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                } or {},
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    -- To scroll through a big popup window
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    -- Show autocomplete options without typing anything
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        }),
                        { "i", "c" }
                    ),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ["<S-CR>"] = cmp.mapping.confirm({
                    --   behavior = cmp.ConfirmBehavior.Replace,
                    --   select = true,
                    -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    --
                    -- Make SuperTab
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        -- I have my own keybinds for this in luasnip config
                        -- elseif luasnip.expand_or_jumpable() then
                        --     luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        -- elseif luasnip.jumpable(-1) then
                        --     luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 }, -- enable type checking to develop neovim (neodev 2.0)
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lsp" },
                    {
                        name = "latex_symbols",
                        option = {
                            -- @usage 0 (mixed) | 1 (julia) | 2 (latex)
                            strategy = 0,
                        },
                    },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 1 }, -- keyword_length specifies word length to start suggestions
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                        },
                    },
                }),
                -- use defaults for sorting stragegy
                sorting = require("cmp.config.default")().sorting,
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icons = require("core.icons").kinds
                        item.kind = icons[item.kind] or ""
                        item.menu = ({
                            copilot = "[copilot]",
                            nvim_lsp = "[LSP]",
                            nvim_lsp_signature_help = "[sign]",
                            latex_symbols = "[symb]",
                            luasnip = "[snip]",
                            path = "[path]",
                            spell = "[spell]",
                            buffer = "[buf]",
                            cmdline = "[cmd]",
                        })[entry.source.name]
                        return item
                    end,
                },
                experimental = {
                    -- @usage boolean | { hl_group = string }
                    ghost_text = CONFIG.ui.ghost_text, -- show completion preview inline
                },
            }

            -- if copilot is enabled update priority
            if CONFIG.lsp.enable_copilot and vim.fn.executable("node") == 1 and vim.g.neovide == nil then
                table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })
                table.insert(opts.sorting.comparators, 1, require("copilot_cmp.comparators").prioritize)
            end

            cmp.setup(opts)

            -- Set configuration for specific filetype.
            -- cmp.setup.filetype('gitcommit', {
            --     sources = cmp.config.sources({
            --         { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            --     }, {
            --         { name = 'buffer' },
            --     })
            -- })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline", keyword_length = 2 }, -- otherwise too much info
                }),
            })
        end,
    },

    -- enable type checking to develop neovim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                -- Only load the lazyvim library when the `LazyVim` global is found
                { path = "LazyVim", words = { "LazyVim" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
            },
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

    -- auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true, -- work with treesitter
            -- ts_config = {
            --     lua = {'string'},-- it will not add a pair on that treesitter node
            --     javascript = {'template_string'},
            --     java = false,-- don't check treesitter on java
            -- },
            disable_filetype = { "TelescopePrompt", "spectre_panel", "vim", "text", "markdown" },
            disable_in_macro = true, -- disable when recording or executing a macro
            -- I use this instead of surround for now
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'", "`" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            npairs.setup(opts)

            -- Create a rule to add spaces between parentheses
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            npairs.add_rules({
                Rule(" ", " "):with_pair(function(options)
                    local pair = options.line:sub(options.col - 1, options.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),
            })
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(options)
                            return options.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                })
            end

            -- A rule for arrow key on javascript
            Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
                :use_regex(true)
                :set_end_pair_length(2)
        end,
    },

    -- close tags using treesitter
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "InsertEnter",
        config = true,
    },
}
