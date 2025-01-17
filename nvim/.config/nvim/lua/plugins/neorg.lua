-- advanced note taking, project/task management
return {
    {
        "nvim-neorg/neorg",
        -- TODO: repin
        commit = "086891d", -- it updates too fast for me to care
        build = ":Neorg sync-parsers",
        ft = "norg",
        dependencies = {
            "plenary.nvim",
            "nvim-treesitter",
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
                    -- ["core.dirman"] = { -- Manages Neorg workspaces
                    --     config = {
                    --         workspaces = {
                    --             notes = "~/notes",
                    --         },
                    --     },
                    -- },
                    -- https://github.com/nvim-neorg/neorg/wiki/Completion#configuration
                    -- ["core.completion"] = {
                    --     config = { engine = "nvim-cmp" },
                    -- },
                },
            })

            vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", { desc = "Toggle Neorg Concealer" })
        end,
    },
}
