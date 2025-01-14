-- Comment plugin with has some nice keybindings
return {
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
            -- FIX: remove the warning
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
}
