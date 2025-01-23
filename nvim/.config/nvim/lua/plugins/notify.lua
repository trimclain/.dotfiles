-- better `vim.notify()`
return {
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
            local Util = require("core.util")

            -- when noice is not enabled, install notify on VeryLazy
            if not Util.has_plugin("noice.nvim") then
                Util.on_very_lazy(function()
                    vim.notify = require("notify")
                end)
            end
        end,
    },

    -- UI for nvim-lsp's progress handler (loading animation at startup on bottom right)
    -- TODO: both this and notify have same capabilities in their latest versions. I should really pick one.
    -- Or go with snacks.nvim/mini.nvim alternative.
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy",
        cond = CONFIG.plugins.spinner,
        opts = {
            text = {
                spinner = CONFIG.plugins.spinner_type,
            },
            window = {
                relative = "editor", -- where to anchor, either "win" or "editor" (default: "win")
                blend = CONFIG.ui.transparent_background and 0 or 100, -- &winblend for the window (default: 100)
            },
        },
    },
}
