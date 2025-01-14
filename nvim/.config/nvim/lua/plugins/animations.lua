return {
    -- smooth scrolling
    -- althernative: https://github.com/declancm/cinnamon.nvim
    {
        "karb94/neoscroll.nvim",
        cond = CONFIG.ui.neoscroll,
        event = { "BufReadPost" },
        opts = {
            -- All these keys will be mapped to their corresponding default scrolling animation
            -- mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
            mappings = {},
            hide_cursor = false, -- Hide cursor while scrolling (default: true)
            stop_eof = true, -- Stop at <EOF> when scrolling downwards (default: true)
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            -- Docs: https://github.com/karb94/neoscroll.nvim?tab=readme-ov-file#easing-functions
            easing = "sine", -- Default easing function. Options: linear, quadratic, cubic, quartic, quintic, circular, sine
        },
        config = function(_, opts)
            local neoscroll = require("neoscroll")
            neoscroll.setup(opts)

            -- stylua: ignore
            local keymaps = {
                ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end;
                ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end;
                -- ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end;
                -- ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end;
                -- ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 100 }) end;
                -- ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 100 }) end;
                ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end;
                ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
                ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end;
            }
            for key, func in pairs(keymaps) do
                vim.keymap.set({ "n", "v", "x" }, key, func)
            end
        end,
    },

    -- cursor animation
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.2") == 1,
        cond = CONFIG.ui.smear_cursor and vim.g.neovide == nil,
        opts = {
            hide_target_hack = true,
            -- cursor_color = "none",
        },
    },
}
