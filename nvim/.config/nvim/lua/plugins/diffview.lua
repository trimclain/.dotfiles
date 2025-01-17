-- better git diff
return {
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-web-devicons",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        keys = {
            {
                "<leader>gdo",
                function()
                    local diffview = require("diffview")
                    diffview.open({})
                    vim.keymap.set("n", "q", function()
                        diffview.close()
                        vim.keymap.del("n", "q")
                    end, {})
                end,
                desc = "Open DiffView",
            },
            -- { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close DiffView" },
            { "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "DiffView Toggle Files" },
        },
    },
}
