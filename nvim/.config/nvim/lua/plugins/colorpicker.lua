return {
    -- preview colors in neovim
    {
        "catgoose/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        -- keys = {
        --     { "<leader>cr",  "<cmd>ColorizerReloadAllBuffers<cr>", desc = "ColorizeReload" },
        -- },
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB, RRGGBBAA
                    ccs_fn = true,
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = "background", -- set the display mode
                    -- Available methods are false / true / "normal" / "lsp" / "both"
                    -- True is same as normal
                    tailwind = false, -- Enable tailwind colors
                    -- parsers can contain values used in |user_default_options|
                    sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
                    virtualtext = "■",
                    -- update color values even if buffer is not focused
                    -- example use: cmp_menu, cmp_docs
                    always_update = false,
                },
                filetypes = { "*" },
                -- all the sub-options of filetypes apply to buftypes
                buftypes = {
                    "*",
                    -- exclude prompt and popup buftypes from highlight
                    "!prompt",
                    "!popup",
                },
            })
        end,
    },

    -- color picker
    {
        "KabbAmine/vCoolor.vim",
        enabled = vim.fn.executable("zenity") == 1 or vim.fn.executable("yad") == 1,
        keys = {
            { "<M-c>", "<cmd>VCoolor<cr>", desc = "Open Colorpicker", mode = { "n", "i" } },
        },
        config = function()
            vim.g.vcoolor_disable_mappings = 1
            -- vim.g.vcoolor_lowercase = 1
        end,
    },

    -- -- alternative to colorizer and colorpicker in one plugin:
    -- {
    --     "uga-rosa/ccc.nvim",
    --     event = { "BufReadPost", "BufNewFile" },
    --     keys = {
    --         { "<M-c>", "<cmd>CccPick<cr>", desc = "Open Colorpicker" },
    --     },
    --     opts = {
    --         win_opts = {
    --             border = CONFIG.ui.border,
    --         },
    --         -- highlight_mode = "virtual", -- "fg" | "bg" (default) | "foreground" | "background" | "virtual"
    --         -- virtual_symbol = " ■ ", -- default: " ● "
    --         highlighter = {
    --             auto_enable = true, -- enable colorizer
    --         },
    --     },
    -- },

    -- can't make it work for some reason
    -- {
    --     "nvzone/minty",
    --     dependencies = "nvzone/volt",
    --     cmd = { "Shades", "Huefy" },
    -- },
}
