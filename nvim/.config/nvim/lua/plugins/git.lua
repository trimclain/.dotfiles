local Icons = require("core.icons").ui

return {
    -- git client
    {
        "NeogitOrg/neogit",
        -- dir = "~/projects/open-source/nvim-plugins/neogit",
        -- https://github.com/NeogitOrg/neogit/tree/68a3e90e9d1ed9e362317817851d0f34b19e426b?tab=readme-ov-file#configuration
        commit = "68a3e90", -- pin until it's fixed
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        -- TODO: https://superuser.com/questions/887712/how-do-i-change-the-hilighted-length-of-git-commit-messages-in-vim
        config = function()
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

    -- better git diff
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
        keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signcolumn = CONFIG.git.show_signcolumn, -- Toggle with `:Gitsigns toggle_signs`
            current_line_blame = CONFIG.git.show_line_blame, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                delay = 500,
            },
            current_line_blame_formatter = "    <author>, <author_time:%R> - <summary>",
            current_line_blame_formatter_nc = "    <author>",
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- Navigation
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")

                -- Actions
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                -- stylua: ignore start
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle Current Line Blame")
                map("n", "<leader>ghl", gs.toggle_linehl, "Toggle Line Highlight")
                map("n", "<leader>ghw", gs.toggle_word_diff, "Toggle Word Diff")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                -- stylua: ignore end

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
}
