return {
    -- the GOATs used by others:
    { "nvim-lua/plenary.nvim", lazy = true }, -- library used by other plugins
    { "nvim-tree/nvim-web-devicons", lazy = true }, -- icons
    { "MunifTanjim/nui.nvim", lazy = true }, -- ui components

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

    -- For aligning tables
    -- { "godlygeek/tabular" }

    -- makes some plugins dot-repeatable like flash.nvim
    ---{ "tpope/vim-repeat", event = "VeryLazy" },

    -- I use snippets instead, but in case I want here's the link
    -- wisely add "end" in Ruby, Vimscript, Lua, etc
    -- {
    --     "RRethy/nvim-treesitter-endwise",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- },

    -- I might find a use fo this one later
    -- tab out from parentheses, quotes, and similar contexts
    -- {
    --     "abecodes/tabout.nvim",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- },

    -- from plugin/ui.lua
    -- foldcolumn
    -- { "kevinhwang91/nvim-ufo" },

    -- SOMEDAY: in case I want to replace the command line with a ui
    -- noicer ui
    -- NOTE: this plugin includes fidget.nvim
    -- {
    --   "folke/noice.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     lsp = {
    --       override = {
    --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --         ["vim.lsp.util.stylize_markdown"] = true,
    --       },
    --     },
    --     presets = {
    --       bottom_search = true,
    --       command_palette = true,
    --       long_message_to_split = true,
    --     },
    --   },
    --   -- stylua: ignore
    --   keys = {
    --     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    --     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    --     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    --     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    --     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
    --     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    --   },
    -- },

    -- UI for nvim-lsp's progress handler (loading animation at startup on bottom right)
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy", -- TODO: update to later tag
        cond = CONFIG.ui.spinner,
        opts = {
            text = {
                spinner = CONFIG.ui.spinner_type,
            },
            window = {
                relative = "editor", -- where to anchor, either "win" or "editor" (default: "win")
                blend = CONFIG.ui.transparent_background and 0 or 100, -- &winblend for the window (default: 100)
            },
        },
    },
}
