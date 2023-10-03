-------------------------------------------------------------------------------
--                                                                           --
--   ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗    --
--   ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║    --
--      ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║    --
--      ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║    --
--      ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║    --
--      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    --
--                                                                           --
--       Arthur McLain (trimclain)                                           --
--       mclain.it@gmail.com                                                 --
--       https://github.com/trimclain                                        --
--                                                                           --
-------------------------------------------------------------------------------

-- Important settings for easy modification
CONFIG = {
    opts = {
        -- textwidth = 120,
        tabwidth = 4,
        -- escape_keys = { "jk", "JK", "jj" },
    },
    lsp = {
        format_on_save = false,
        virtual_text = false,
        show_signature_help = true,
        enable_copilot = vim.fn.hostname() == "arch",
    },
    ui = {
        -- Colorschemes (note/10):
        -- catppuccin (9), tokyonight (9), rose-pine (9), tundra (9), astrotheme (9)
        -- nightfox (8), vscode (8), gruvbox (8)
        -- github-dark (7), onedark (7), kanagawa (7), zephyr (7)
        -- sonokai (6), omni (6),
        colorscheme = "rose-pine",
        transparent_background = false,
        cursorline = true,
        border = "rounded", -- see `:h nvim_open_win`
        italic_comments = true,
        dashboard = true,
        neoscroll = false,
        ghost_text = false,

        -- Spinners: dots_pulse, moon, meter, zip, pipe, dots, arc
        spinner = "dots_pulse", -- animation shown when tasks are ongoing

        -- Builder
        builder_type = "bot", -- "bot": bottom horizontal split, "vert": right vertical split, "float": floating window
    },
    git = {
        show_blame = false,
        show_signcolumn = true,
    },
}

require("core.options")
require("core.autocmd")
require("core.lazy")
require("core.keymaps")
