return {
    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- TODO: someday?
    -- session management
    -- {
    --     "folke/persistence.nvim",
    --     event = "BufReadPre",
    --     opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    --     -- stylua: ignore
    --     keys = {
    --         { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    --         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    --         { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    --     },
    -- },

    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },

    -- TODO: if I use leap someday
    -- makes some plugins dot-repeatable like leap
    ---{ "tpope/vim-repeat", event = "VeryLazy" },
}
