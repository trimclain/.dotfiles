-- select and input UI
return {
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(items, opts, on_choice)
                if not package.loaded["dressing.nvim"] then
                    require("lazy").load({ plugins = { "dressing.nvim" } })
                end
                -- Don't show the picker if there's nothing to pick.
                if #items > 0 then
                    return vim.ui.select(items, opts, on_choice)
                end
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                if not package.loaded["dressing.nvim"] then
                    require("lazy").load({ plugins = { "dressing.nvim" } })
                end
                return vim.ui.input(...)
            end
        end,
    },
}
