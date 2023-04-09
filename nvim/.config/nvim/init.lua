--#############################################################################
--        ______ ___    __ __   ___    ____  __     __     __  __   __
--       /_  __//   \  / //  \ /   |  / __/ / /    /  |   / / /  \ / /
--        / /  /   _/ / // /\\/ /| | / /   / /    /   |  / / / /\\/ /
--       / /  / /\ \ / // / \/_/ | |/ /__ / /___ / _  | / / / / \/ /
--      /_/  /_/ \_\/_//_/       |_|\___//_____//_/ \_|/_/ /_/  /_/
--
--
--       Arthur McLain (trimclain)
--       mclain.it@gmail.com
--       https://github.com/trimclain
--
--#############################################################################

-- Important settings for easy modification
CONFIG = {
    opts = {
        -- textwidth = 120,
        tabwidth = 4,
        -- escape_keys = { "jk", "JK", "jj" },
    },
    lsp = {
        format_on_save = false,
        virtual_text = false, -- { spacing = 4, prefix = "●" }
        show_signature_help = true,
        -- show_diagnostic = true,
    },
    ui = {
        -- Colorschemes (note/10): tokyonight (9), catppuccin (9), tundra (9), kanagawa (8), nightfox (8), rose-pine (8), zephyr (7), sonokai (6), vscode (5), omni (6)
        colorscheme = "tundra",
        border = "rounded", -- see ':h nvim_open_win'
        italic_comments = true,
        dashboard = true,
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
