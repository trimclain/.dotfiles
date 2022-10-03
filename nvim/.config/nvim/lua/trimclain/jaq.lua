local status_ok, jaq_nvim = pcall(require, "jaq-nvim")
if not status_ok then
    return
end

jaq_nvim.setup {
    cmds = {
        -- Uses vim commands
        internal = {
            lua = "luafile %",
            vim = "source %",
        },

        -- Uses shell commands
        external = {
            typescript = "ts-node %",
            javascript = "node %",
            -- markdown = "glow %",
            python = "python3 %",
            -- rust = "cargo run",
            -- cpp = "g++ % -o $fileBase && ./$fileBase",
            go = "go run %",
            sh = "bash %",
            julia = "julia %",
        },
    },

    behavior = {
        -- Default type
        default = "terminal", -- options: "float", "bang", "quickfix", "terminal"

        -- Start in insert mode
        startinsert = false,

        -- Use `wincmd p` on startup
        wincmd = false,

        -- Auto-save files
        autosave = true,
    },

    ui = {
        float = {
            -- See ':h nvim_open_win'
            border = "none",

            -- See ':h winhl'
            winhl = "Normal",
            borderhl = "FloatBorder",

            -- See ':h winblend'
            winblend = 0,

            -- Num from `0-1` for measurements
            height = 0.8,
            width = 0.8,
            x = 0.5,
            y = 0.5,
        },

        terminal = {
            -- Window position
            -- position = "bot",
            position = "vert",

            -- Window size
            -- size = 10,
            size = 60,

            -- Disable line numbers
            line_no = false,
        },

        quickfix = {
            -- Window position
            position = "bot",

            -- Window size
            size = 10,
        },
    },
}
