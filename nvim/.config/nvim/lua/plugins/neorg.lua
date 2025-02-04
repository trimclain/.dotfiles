-- advanced note taking, project/task management
return {
    {
        "nvim-neorg/neorg",
        version = "*",
        ft = "norg",
        dependencies = {
            "nvim-treesitter",

            -- no need for luarocks, I'll do it myself
            "nui.nvim",
            "plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-neorg/lua-utils.nvim",
            "pysan3/pathlib.nvim",
        },
        config = function()
            require("neorg").setup({
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = { -- Adds pretty icons to your documents
                        config = {
                            icon_preset = "basic", -- "basic" (default), "diamond", "varied"
                        },
                    },
                },
            })

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2

            vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", { desc = "Toggle Neorg Concealer" })
        end,
    },
}
