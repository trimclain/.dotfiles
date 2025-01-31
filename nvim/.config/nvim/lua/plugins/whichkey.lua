-- never forget your keymaps
return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = {
                marks = false, -- shows a list of your marks on ' and `
                registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                presets = {
                    operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                    motions = false, -- adds help for motions
                    text_objects = false, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            -- key_labels = {
            --     -- ["<space>"] = "SPC",
            --     ["<leader>"] = "Space",
            --     -- ["<cr>"] = "RET",
            --     -- ["<tab>"] = "TAB",
            -- },
            win = {
                border = CONFIG.ui.border,
            },
            layout = {
                align = "center", -- align columns left, center or right
            },
            show_help = false, -- show help message on the command line when the popup is visible
            spec = {
                {
                    mode = { "n" },
                    { "g", group = "goto" },
                    -- {"gz", group = "surround" },
                    { "]", group = "next" },
                    { "[", group = "prev" },
                    -- {"<leader><tab>", group = "tabs" },
                    -- {"<leader>b", group = "buffer" },
                    { "<leader>d", group = "document" },
                    { "<leader>f", group = "find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gd", group = "diffview" },
                    { "<leader>h", group = "git hunks" },
                    { "<leader>l", group = "lsp" },
                    { "<leader>m", group = "make" },
                    { "<leader>n", group = "neorg/neotest" },
                    { "<leader>o", group = "options" },
                    { "<leader>p", group = "plugins" },
                    { "<leader>r", group = "replace/refactor" },
                    { "<leader>s", group = "splitjoin" },
                    { "<leader>t", group = "tab/terminal" },
                    -- {"<leader>j", group = "tbd" },
                    -- {"<leader>k", group = "tbd" },
                    -- {"<leader>v", group = "tbd" },
                    -- {"<leader>x", group = "tbd" },
                    -- {"<leader>c", group = "tbd" },
                },
                {
                    mode = { "v" },
                    { "<leader>g", group = "+git" },
                    { "<leader>gh", group = "+hunks" },
                    { "<leader>l", group = "+lsp" },
                    { "<leader>r", group = "+refactor" },
                },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
        end,
    },
}
