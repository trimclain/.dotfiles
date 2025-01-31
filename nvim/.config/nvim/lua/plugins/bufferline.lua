-- bufferline
return {
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-web-devicons",
        event = { "BufNewFile", "BufReadPre" },
        cond = CONFIG.plugins.bufferline,
        -- keys = {
        --   { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
        --   { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
        -- },
        opts = {
            options = {
                show_close_icon = false, --default: true
                separator_style = CONFIG.ui.transparent_background and "thin" or "slant", -- | "thick" | "slant" | default: "thin" | "padded_slant"  | { 'any', 'any' }
                -- enforce_regular_tabs = true, -- default: false
                max_name_length = 30, -- default 18
                max_prefix_length = 30, -- prefix used when a buffer is de-duplicated, default 15
                tab_size = 21, -- default 18
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-Tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            if CONFIG.ui.colorscheme == "catppuccin" then
                opts = vim.tbl_extend("force", opts, {
                    highlights = require("catppuccin.groups.integrations.bufferline").get(),
                })
            end
            require("bufferline").setup(opts)
        end,
    },
}
