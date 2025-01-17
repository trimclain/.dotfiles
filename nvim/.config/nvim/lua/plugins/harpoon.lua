-- harpoon btw
return {
    -- PERF: this takes 7-8 ms on startup even though it's lazy loaded... Why??
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = "plenary.nvim",
        -- dir = "~/projects/open-source/nvim-plugins/harpoon",
        -- stylua: ignore
        keys = function()
            local harpoon = require("harpoon")
            return {
                { "<leader>a", function() harpoon:list():add() end, desc = "Add Harpoon Mark" },
                { "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Toggle Harpoon Menu" },
                { "<C-j>", function() harpoon:list():select(1) end, desc = "Harpoon to file 1" },
                { "<C-k>", function() harpoon:list():select(2) end, desc = "Harpoon to file 2" },
                { "<C-h>", function() harpoon:list():select(3) end, desc = "Harpoon to file 3" },
                { "<C-g>", function() harpoon:list():select(4) end, desc = "Harpoon to file 4" },
            }
        end,
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            require("harpoon"):setup(opts)
        end,
    },
}
