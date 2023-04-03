return {
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        -- build = (not jit.os:find("Windows"))
        --     and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
        --   or nil,
        -- TODO: does this solve my not knowing where to put stuff?
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                -- TODO: maybe there's a better place for this
                -- require("luasnip").filetype_extend("javascript", { "javascriptreact", "html" }) -- add jsx and html snippets to js
                -- require("luasnip").filetype_extend("javascriptreact", { "javascript", "html" }) -- add js and html snippets to jsx
                -- require("luasnip").filetype_extend("typescriptreact", { "javascript", "html" }) -- add js and html snippets to tsx
            end,
        },
        opts = {
            history = true,
            update_events = { "TextChanged", "TextChangedI" },
            delete_check_events = "TextChanged",
        },
    -- stylua: ignore
    keys = {
      {

          "<c-k>",
          function()
              if require("luasnip").expand_or_jumpable() then
                  require("luasnip").expand_or_jump()
              end
          end,
          silent = true, mode = { "i", "s" }
      },
      {
          "<c-j>",
          function()
              if require("luasnip").jumpable(-1) then
                  require("luasnip").jump(-1)
              end
          end,
          silent = true, mode = { "i", "s" }
      },
      {
          "<c-l>",
          function()
              if require("luasnip").choice_active() then
                  require("luasnip").change_choice(1)
              end
          end,
          mode = "i"
      },
    },
    },

    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            return {
                -- completion = {
                --   completeopt = "menu,menuone,noinsert",
                -- },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                -- Make it round
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    -- To scroll through a big popup window
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    -- Show autocomplete options without typing anything
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- TODO: will I use this?
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
                -- TODO:
                -- sources = cmp.config.sources({
                --     -- the order sets priority
                --     { name = "nvim_lsp" },
                --     { name = "nvim_lua" },
                --     { name = "luasnip" },
                --     { name = "path" },
                --     {
                --         name = "spell",
                --         option = {
                --             keep_all_entries = false,
                --             enable_in_context = function()
                --                 return true
                --             end,
                --         },
                --     },
                -- }, {
                --     { name = "buffer", keyword_length = 1 }, -- keyword_length specifies word length to start suggestions
                -- }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icons = require("core.icons").kinds
                        item.kind = icons[item.kind] or ""
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[lua]",
                            luasnip = "[snip]",
                            buffer = "[buf]",
                            path = "[path]",
                            cmdline = "[cmd]",
                            spell = "[spell]",
                        })[entry.source.name]
                        return item
                    end,
                },
                experimental = {
                    ghost_text = true, -- show completion preview inline
                    -- ghost_text = {
                    --   hl_group = "LspCodeLens",
                    -- },
                },
            }
        end,
    },

    -- TODO:
    -- -- Set configuration for specific filetype.
    -- -- cmp.setup.filetype('gitcommit', {
    -- --     sources = cmp.config.sources({
    -- --         { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    -- --     }, {
    -- --         { name = 'buffer' },
    -- --     })
    -- -- })
    --
    -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline({ "/", "?" }, {
    --     mapping = cmp.mapping.preset.cmdline(),
    --     sources = {
    --         { name = "buffer" },
    --     },
    -- })
    --
    -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline(":", {
    --     mapping = cmp.mapping.preset.cmdline(),
    --     sources = cmp.config.sources({
    --         { name = "path" },
    --     }, {
    --         { name = "cmdline", keyword_length = 2 }, -- otherwise too much info
    --     }),
    -- })

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
            disable_filetype = { "TelescopePrompt", "spectre_panel", "vim", "text" },
            disable_in_macro = true, -- disable when recording or executing a macro
            -- I use this instead of surround for now
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
        },
        config = function(_, opts)
            -- Create a ule to add spaces between parentheses
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            npairs.setup(opts)


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
        end,
    },

    -- close tags using treesitter
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
    },

    -- comments
    -- FIX: make pre_hook work
    -- { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        -- dependencies = {
        --     "JoosepAlviste/nvim-ts-context-commentstring",
        -- },
        opts = {
            ignore = "^$", -- ignores empty lines
            -- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            -- pre_hook = function()
            --     require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
            -- end,
        },
        config = function(_, opts)
            require("Comment").setup(opts)
        end,
    },
    -- comments
    -- { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    -- {
    --     "echasnovski/mini.comment",
    --     event = "VeryLazy",
    --     opts = {
    --         hooks = {
    --             pre = function()
    --                 require("ts_context_commentstring.internal").update_commentstring({})
    --             end,
    --         },
    --     },
    --     config = function(_, opts)
    --         require("mini.comment").setup(opts)
    --     end,
    -- },
    -- TODO:
    -- Manually set filetype comments
    -- local comment_ft = require "Comment.ft"
    -- comment_ft.set("lua", { "--%s", "--[[%s]]" })
    -- comment_ft.set("markdown", { "[//]:%s", "<!--%s-->" })

    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = {
            {
                "<leader>ng",
                function()
                    require("neogen").generate({ type = "func" })
                end,
                desc = "Generate annotations for current function",
            },
            {
                "<leader>nc",
                function()
                    require("neogen").generate({ type = "class" })
                end,
                desc = "Generate annotations for current class",
            },
            {
                "<leader>nt",
                function()
                    require("neogen").generate({ type = "type" })
                end,
                desc = "Generate annotations for current type",
            },
            {
                "<leader>nf",
                function()
                    require("neogen").generate({ type = "file" })
                end,
                desc = "Generate annotations for current file",
            },
        },
        opts = {
            snippet_engine = "luasnip", -- use provided engine to place the annotations
        },
    },

    -- refactoring btw
    {
        "ThePrimeagen/refactoring.nvim",
        -- stylua: ignore
        keys = {
            { "<leader>rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block (Refactor)" },
            { "<leader>rB", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block To File (Refactor)" },
            { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Extract inline var under cursor (Refactor)" },
            { "<leader>rf", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function", mode = { "v" } },
            { "<leader>rF", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function To File", mode = { "v" } },
            { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable", mode = { "v" } },
            { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Extract Inline Variable", mode = { "v" } },
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
        },
    },

    -- Neovim plugin for splitting/joining blocks of code
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },
}
