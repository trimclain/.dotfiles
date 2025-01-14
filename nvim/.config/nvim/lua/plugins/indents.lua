local Icons = require("core.icons")

return {
    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        -- for setting shiftwidth and tabstop automatically
        -- dependencies = "tpope/vim-sleuth",
        cond = CONFIG.ui.indentline,
        opts = {
            indent = {
                char = Icons.ui.LineLeft,
                -- char = "│",
                tab_char = Icons.ui.LineLeft,
                -- tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "lazy",
                    "mason",
                    "neo-tree",
                    "notify",
                    "neogitstatus",
                    "undotree",
                    "toggleterm",
                },
            },
        },
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        cond = CONFIG.ui.indentline,
        opts = {
            symbol = Icons.ui.LineLeft,
            -- symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    ---@diagnostic disable-next-line: inject-field
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },

}
