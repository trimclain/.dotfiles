-- documentation comments
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
                desc = "Neogen: annotate current function",
            },
            {
                "<leader>dc",
                function()
                    require("neogen").generate({ type = "class" })
                end,
                desc = "Neogen: annotate current class",
            },
            {
                "<leader>dt",
                function()
                    require("neogen").generate({ type = "type" })
                end,
                desc = "Neogen: annotate current type",
            },
            {
                "<leader>df",
                function()
                    require("neogen").generate({ type = "file" })
                end,
                desc = "Neogen: annotate current file",
            },
        },
        opts = {
            snippet_engine = CONFIG.plugins.use_blink_completion and "nvim" or "luasnip", -- use provided engine to place the annotations
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
