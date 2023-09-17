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
        -- catppuccin (9), tokyonight (9), rose-pine (9), tundra (9)
        -- nightfox (8), vscode (8), gruvbox (8)
        -- github-dark (7), onedark (7), kanagawa (7), zephyr (7)
        -- sonokai (6), omni (6),
        -- darkplus (why does it change colors 5 seconds after launch?)
        colorscheme = "vscode",
        transparent_background = false,
        border = "rounded", -- see ':h nvim_open_win'
        italic_comments = true,
        dashboard = true,
        neoscroll = false,
        ghost_text = false,

        -- Spinners: dots_pulse, moon, meter, zip, pipe, dots, arc
        spinner = "dots_pulse", -- animation shown when tasks are ongoing

        -- builder
        builder_position = "bot", -- "bot": bottom horizontal split, "vert": right vertical split
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
