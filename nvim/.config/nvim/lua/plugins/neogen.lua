-- documentation comments
-- TODO: works with luasnip
return {
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
}
