-- run tests in neovim
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "plenary.nvim",
            "nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-plenary",
        },
        -- stylua: ignore
        keys = {
            { "<leader>nt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest Run File" },
            { "<leader>nT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Neotest Run All Test Files" },
            { "<leader>nr", function() require("neotest").run.run() end, desc = "Neotest Run Nearest" },
            { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Neotest Toggle Summary" },
            { "<leader>no", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Neotest Show Output" },
            { "<leader>nO", function() require("neotest").output_panel.toggle() end, desc = "Neotest Toggle Output Panel" },
            { "<leader>nS", function() require("neotest").run.stop() end, desc = "Neotest Stop" },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary").setup({
                        -- min_init = "./tests/init.lua",
                    }),
                },
            })
        end,
    },
}
