-- TODO: where to put the other plugins?
local Util = require("core.util")

return {
    -- better `vim.notify()`
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader><space>",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Delete all Notifications",
            },
            -- { "<leader>ns", "<cmd>Notifications<cr>", desc = "Show all Notifications" },
        },
        opts = {
            timeout = 1500,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            -- used for 100% transparency (NotifyBackground links to Normal, which is not defined when transparency is enabled)
            background_colour = CONFIG.ui.transparent_background and "#1e1e2e" or "NotifyBackground",
        },
        init = function()
            -- when noice is not enabled, install notify on VeryLazy
            if not Util.has_plugin("noice.nvim") then
                Util.on_very_lazy(function()
                    vim.notify = require("notify")
                end)
            end
        end,
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

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

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true },
}
