return {
    -- preview colors in neovim
    {
        "catgoose/nvim-colorizer.lua",
        event = "VeryLazy",
        -- keys = {
        --     { "<leader>cr",  "<cmd>ColorizerReloadAllBuffers<cr>", desc = "ColorizeReload" },
        -- },
        config = function()
            require("colorizer").setup({
                lazy_load = true,
                user_default_options = {
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB, RRGGBBAA
                    ccs_fn = true,
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = "background", -- set the display mode
                    -- Tailwind colors:  boolean|"normal"|"lsp"|"both".  True sets to "normal"
                    tailwind = "normal", -- Enable tailwind colors
                    tailwind_opts = { -- Options for highlighting tailwind names
                        -- When using tailwind = "both", update tailwind names from LSP results.
                        -- See: https://github.com/catgoose/nvim-colorizer.lua?tab=readme-ov-file#tailwind
                        update_names = false,
                    },
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
