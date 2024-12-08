---@diagnostic disable: missing-fields
return {
    -- I use snippets instead, but in case I want here's the link
    -- wisely add "end" in Ruby, Vimscript, Lua, etc
    -- {
    --     "RRethy/nvim-treesitter-endwise",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- },

    -- I might find a use fo this one later
    -- tab out from parentheses, quotes, and similar contexts
    -- {
    --     "abecodes/tabout.nvim",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- },

    -- comments
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                config = function()
                    vim.g.skip_ts_context_commentstring_module = true
                    require("ts_context_commentstring").setup({
                        enable_autocmd = false,
                    })
                end,
            },
        },
        config = function()
            require("Comment").setup({
                ignore = "^$", -- ignores empty lines
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })

            local comment_ft = require("Comment.ft")
            comment_ft.set("rasi", { "//%s", "/*%s*/" }) -- rofi config
            -- comment_ft.set("lua", { "--%s", "--[[%s]]" })
            -- comment_ft.set("markdown", { "[//]:%s", "<!--%s-->" })
        end,
    },

    -- documentation comments
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = {
            {
                "<leader>dg",
                function()
                    require("neogen").generate({ type = "func" })
                end,
                desc = "Generate annotations for current function",
            },
            {
                "<leader>dc",
                function()
                    require("neogen").generate({ type = "class" })
                end,
                desc = "Generate annotations for current class",
            },
            {
                "<leader>dt",
                function()
                    require("neogen").generate({ type = "type" })
                end,
                desc = "Generate annotations for current type",
            },
            {
                "<leader>df",
                function()
                    require("neogen").generate({ type = "file" })
                end,
                desc = "Generate annotations for current file",
            },
        },
        opts = {
            snippet_engine = "luasnip", -- use provided engine to place the annotations
            languages = {
                -- Supported languages: https://github.com/danymat/neogen#configuration
                lua = {
                    template = {
                        annotation_convention = "emmylua",
                    },
                },
            },
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
            { "gs", "<cmd>TSJToggle<cr>", desc = "Toggle SplitJoin" }, -- defailt gs is :sleep (kinda useless)
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },
}
