local Icons = require("core.icons")

-- Alternative: https://github.com/echasnovski/mini.hipatterns (combines colorizer)
return {
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "Todo" }
            -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = Icons.ui.Bug, -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = Icons.ui.Check, color = "info" },
                HACK = { icon = Icons.ui.Fire, color = "warning" },
                WARN = {
                    icon = Icons.diagnostics.BoldWarn,
                    color = "warning",
                    alt = { "WARNING", "XXX" },
                },
                PERF = { icon = Icons.ui.Clock, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = Icons.ui.Message, color = "hint", alt = { "INFO", "IDEA" } },
                TEST = { icon = Icons.ui.Speedometer, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- search hidden files/directories
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        },
    },
}
