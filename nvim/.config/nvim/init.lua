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

-- Fast way to switch to minimal (in terms of ui) config
local type = "default" --- @usage: "default" | "minimal"

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
        enable_copilot = vim.fn.has("unix") == 1 and vim.fn.has("wsl") == 0,
    },
    ui = {
        -- Colorschemes (note/10):
        -- astrospeed (10)
        -- catppuccin (9), tokyonight (9), rose-pine (9), tundra (9), astrotheme (9)
        -- darkplus (8.5), primer-dark (8), nightfox (8), vscode (8), gruvbox (8)
        -- github-dark (7), onedark (7), kanagawa (7), zephyr (7), poimandres (7)
        -- embark(6), sonokai (6), omni (6),
        colorscheme = "astrospeed",
        transparent_background = false,
        cursorline = true,
        -- border = "rounded", -- see `:h nvim_open_win()`
        border = "none",
        italic_comments = true,
        ghost_text = false,
        inlay_hints = false,
    },
    git = {
        show_line_blame = true,
        show_signcolumn = true,
    },
    plugins = {
        -- use blink.cmp or nvim-cmp
        use_blink_completion = false,
        -- use fzf-lua or telescope.nvim
        use_fzf_lua = vim.fn.executable("fzf") == 1 and false,

        neoscroll = true,
        smear_cursor = false, -- found out about kitty's cursor trail
        -- workflow: no bufferline, use tabs as workspaces with tabby(?), switch between buffers using telescope and harpoon
        bufferline = false, -- to force myself to use harpoon more
        dashboard = type == "default",
        illuminate = type == "default",
        indentline = type == "default",
        lualine = type == "default",
        spinner = type == "default", -- animation shown when tasks are ongoing
        spinner_type = "dots_pulse", -- spinners: dots_pulse, moon, meter, zip, pipe, dots, arc

        -- Builder
        builder_type = "bot", -- "bot": bottom horizontal split, "vert": right vertical split, "float": floating window
    },
}

require("core.options")
require("core.autocmd")
require("core.lazy")
require("core.keymaps")
