-- TODO: where to put the others?
return {

    -- Alternative: "stevearc/quicker.nvim"
    -- TODO: someday
    -- better diagnostics list and others
    -- {
    --     "folke/trouble.nvim",
    --     cmd = { "TroubleToggle", "Trouble" },
    --     opts = { use_diagnostic_signs = true },
    --     keys = {
    --         { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    --         { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    --         { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    --         { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    --         {
    --             "[q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").previous({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cprev()
    --                 end
    --             end,
    --             desc = "Previous trouble/quickfix item",
    --         },
    --         {
    --             "]q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").next({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cnext()
    --                 end
    --             end,
    --             desc = "Next trouble/quickfix item",
    --         },
    --     },
    -- },

    -- zen mode
    {
        "folke/zen-mode.nvim",
        -- dependencies = {
        --     -- twilight
        --     {
        --         "folke/twilight.nvim",
        --         opts = {
        --             alpha = 0.25, -- amount of dimming
        --         },
        --     },
        -- },
        cmd = "ZenMode",
        -- stylua: ignore
        keys = {
            { "<leader>z", function() require("zen-mode").toggle() end, desc = "Toggle Zen Mode" }
        },
        opts = {
            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = false,
                font = "+4", -- font size increment
            },
        },
    },

    -- auto remove search highlight and rehighlight when using n or N
    -- {
    --     "nvimdev/hlsearch.nvim",
    --     config = true,
    -- },

    -- incsearch for :linenum<cr>
    -- {
    --     "nacro90/numb.nvim",
    --     event = "BufReadPost",
    --     config = true,
    -- },
}
