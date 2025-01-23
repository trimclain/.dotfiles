-- Git decorations
return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local bold_line_left = require("core.icons").ui.BoldLineLeft
            local dashed_line = require("core.icons").ui.DashedLine

            return {
                signs = {
                    add = { text = bold_line_left },
                    change = { text = bold_line_left },
                    delete = { text = bold_line_left },
                    topdelete = { text = bold_line_left },
                    changedelete = { text = bold_line_left },
                    untracked = { text = bold_line_left },
                },
                signs_staged = {
                    add = { text = dashed_line },
                    change = { text = dashed_line },
                    delete = { text = dashed_line },
                    topdelete = { text = dashed_line },
                    changedelete = { text = dashed_line },
                    untracked = { text = dashed_line },
                },
                signcolumn = CONFIG.git.show_signcolumn, -- Toggle with `:Gitsigns toggle_signs`
                preview_config = { border = CONFIG.ui.border },
                current_line_blame = CONFIG.git.show_line_blame, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    delay = 500,
                },
                current_line_blame_formatter = "    <author>, <author_time:%R> - <summary>",
                current_line_blame_formatter_nc = "    <author>",
                on_attach = function(buffnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buffnr, desc = desc })
                    end

                    -- Navigation
                    map("n", "]h", gs.next_hunk, "Next Hunk")
                    map("n", "[h", gs.prev_hunk, "Prev Hunk")

                    -- Actions
                    -- stylua: ignore
                    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk")
                    map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
                    -- stylua: ignore
                    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")

                    map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
                    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
                    map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
                    -- stylua: ignore
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
                    map("n", "<leader>ht", gs.toggle_current_line_blame, "Toggle Current Line Blame")
                    map("n", "<leader>hl", gs.toggle_linehl, "Toggle Line Highlight")
                    map("n", "<leader>hw", gs.toggle_word_diff, "Toggle Word Diff")
                    map("n", "<leader>hd", gs.diffthis, "Diff This")
                    -- stylua: ignore
                    map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
                    -- map("n", "<leader>hd", gs.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
                end,
            }
        end,
    },
}
