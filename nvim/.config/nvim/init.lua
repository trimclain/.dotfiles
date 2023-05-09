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
    },
    ui = {
        -- Colorschemes (note/10):
        -- catppuccin (10),
        -- tokyonight (9), rose-pine (9), tundra (9)
        -- kanagawa (8), nightfox (8), grail (8)
        -- zephyr (7), onedark (7)
        -- sonokai (6), omni (6),
        -- vscode (5)
        colorscheme = "catppuccin",
        transparent_background = true,
        border = "rounded", -- see ':h nvim_open_win'
        italic_comments = true,
        dashboard = true,
        neoscroll = false,
        ghost_text = false,

        -- Spinners: dots_pulse, moon, meter, zip, pipe, dots, arc
        spinner = "dots_pulse", -- animation shown when tasks are ongoing

        -- Jaq position
        quickrun_position = "vert" -- "bot": bottom horizontal split, "vert": right vertical split
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
