-- TODO: what to do with the others?
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
    -- {
    --     "tweekmonster/startuptime.vim",
    --     cmd = "StartupTime",
    -- },

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

    -- neovim in browser
    -- {
    --     "glacambre/firenvim",
    --     -- Lazy load firenvim
    --     -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    --     cond = not not vim.g.started_by_firenvim,
    --     build = function()
    --         require("lazy").load({ plugins = "firenvim", wait = true })
    --         vim.fn["firenvim#install"](0)
    --     end,
    -- },

    -- preview print statement outputs in neovim (for JS, TS, Python and Lua)
    -- {
    --     "0x100101/lab.nvim",
    --     build = "cd js && npm ci",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     keys = {
    --         { "<leader>1", "<cmd>Lab code run<cr>", desc = "Code run" },
    --         { "<leader>2", "<cmd>Lab code stop<cr>", desc = "Code stop" },
    --         { "<leader>3", "<cmd>Lab code panel<cr>", desc = "Code panel" },
    --     },
    --     config = function()
    --         require("lab").setup({
    --             code_runner = {
    --                 enabled = true,
    --             },
    --             quick_data = {
    --                 enabled = false,
    --             },
    --         })
    --     end,
    -- },

    -- LaTeX support
    -- {
    --     "lervag/vimtex",
    --     -- event = "VeryLazy",
    --     init = function()
    --         vim.g.vimtex_view_method = 'zathura'
    --         vim.g.vimtex_syntax_enabled = 0 -- I use treesitter
    --         -- vim.g.vimtex_compiler_method = 'latexmk'
    --     end,
    --     enabled = vim.fn.executable("latexmk") == 1,
    -- },

    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },

    -- For aligning tables
    -- { "godlygeek/tabular" }

    -- makes some plugins dot-repeatable like flash.nvim
    ---{ "tpope/vim-repeat", event = "VeryLazy" },
}
