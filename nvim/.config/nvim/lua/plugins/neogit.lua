-- git client
return {
    {
        "NeogitOrg/neogit",
        -- dir = "~/projects/open-source/nvim-plugins/neogit",
        -- https://github.com/NeogitOrg/neogit/tree/68a3e90e9d1ed9e362317817851d0f34b19e426b?tab=readme-ov-file#configuration
        commit = "68a3e90", -- pin to the version I like more
        dependencies = {
            "plenary.nvim",
            "diffview.nvim",
            "telescope.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        -- TODO: https://superuser.com/questions/887712/how-do-i-change-the-hilighted-length-of-git-commit-messages-in-vim
        config = function()
            local Icons = require("core.icons").ui
            local neogit = require("neogit")
            neogit.setup({
                disable_commit_confirmation = true, -- config relevant for pinned commit
                disable_insert_on_commit = true, -- "auto", "true" or "false"
                -- Change the default way of opening neogit
                kind = "tab", -- "tab", "split", "split_above", "vsplit", "floating"
                -- The time after which an output console is shown for slow running commands
                --console_timeout = 2000,
                -- Automatically show console if a command takes more than console_timeout milliseconds
                --auto_show_console = true,
                -- override/add mappings
                -- commit_editor = {
                commit_popup = { -- config relevant for pinned commit
                    kind = "split", -- default: "auto"
                },
                signs = {
                    -- { CLOSED, OPENED }
                    section = { Icons.ArrowClosed, Icons.ArrowOpen }, -- default: { ">", "v" },
                    item = { Icons.ArrowClosedSmall, Icons.ArrowOpenSmall }, -- default: { ">", "v" },
                    -- hunk = { "", "" },
                    hunk = { "", "" },
                },
                mappings = {
                    -- popup = {
                    status = { -- config relevant for pinned commit
                        ["P"] = "PullPopup",
                        ["p"] = "PushPopup",
                    },
                },
            })

            -- Close Neogit after `git push`
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeogitPushComplete",
                group = vim.api.nvim_create_augroup("trimclain_close_neogit_after_push", { clear = true }),
                callback = function()
                    neogit.close()
                end,
            })
        end,
    },
}
