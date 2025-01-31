-- Alternative: https://www.lazyvim.org/plugins/ui#snacksnvim
return {
    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        cond = CONFIG.plugins.indentline,
        opts = function()
            local Icons = require("core.icons")
            return {
                indent = {
                    char = Icons.ui.LineLeft,
                    -- char = "│",
                    tab_char = Icons.ui.LineLeft,
                    -- tab_char = "│",
                },
                scope = { enabled = false },
                exclude = {
                    filetypes = require("core.util").get_disabled_filetypes(),
                },
            }
        end,
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        cond = CONFIG.plugins.indentline,
        opts = function()
            local Icons = require("core.icons")
            return {
                symbol = Icons.ui.LineLeft,
                -- symbol = "│",
                options = { try_as_border = true },
            }
        end,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = require("core.util").get_disabled_filetypes(),
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-sleuth" },
}
