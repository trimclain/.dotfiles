return {
    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- session management
    -- {
    --     "folke/persistence.nvim",
    --     event = "BufReadPre",
    --     opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    --     -- stylua: ignore
    --     keys = {
    --         { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    --         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    --         { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    --     },
    -- },

    -- neovim in browser
    -- {
    --     "glacambre/firenvim",
    --     -- Lazy load firenvim
    --     -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    --     cond = not not vim.g.started_by_firenvim,
    --     build = function()
    --         require("lazy").load({ plugins = "firenvim", wait = true })
    --         vim.fn["firenvim#install"](0)
    --     end,
    -- },

    -- quickrun buffer
    {
        "is0n/jaq-nvim",
        -- local_use("jaq-nvim", { branch = "find-json-in-root" })
        cmd = "Jaq",
        keys = {
            { "<C-b>", "<cmd>Jaq<cr>", desc = "Run buffer" },
        },
        opts = {
            cmds = {
                internal = {
                    lua = "luafile %",
                    vim = "source %",
                },
                external = {
                    -- cpp = "g++ % -o $fileBase && ./$fileBase",
                    -- go = "go run %",
                    javascript = "node %",
                    julia = "julia %",
                    tex = "tectonic --chatter=minimal %",
                    -- markdown = "glow %",
                    python = "python3 %",
                    -- rust = "cargo run",
                    sh = "bash %",
                    typescript = "ts-node %",
                    zsh = "zsh %",
                },
            },
            behavior = {
                default = "terminal", -- options: "float", "bang", "quickfix", "terminal"
                autosave = true, -- auto-save files before running
            },
            ui = {
                float = {
                    border = CONFIG.ui.border,
                },
                terminal = {
                    -- position = "bot",
                    -- size = 10,
                    position = "vert",
                    size = 60,
                },
            },
        },
    },

    -- local plugins need to be explicitly configured with dir
    ---{ dir = "~/projects/secret.nvim" },

    -- local plugins can also be configure with the dev option.
    -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from Github
    -- With the dev option, you can easily switch between the local and installed version of a plugin
    ---{ "folke/noice.nvim", dev = true },

    -- preview print statement outputs in neovim (for JS, TS, Python and Lua)
    -- {
    --     "0x100101/lab.nvim",
    --     build = "cd js && npm ci",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     keys = {
    --         { "<leader>1", "<cmd>Lab code run<cr>", desc = "Code run" },
    --         { "<leader>2", "<cmd>Lab code stop<cr>", desc = "Code stop" },
    --         { "<leader>3", "<cmd>Lab code panel<cr>", desc = "Code panel" },
    --     },
    --     config = function()
    --         require("lab").setup({
    --             code_runner = {
    --                 enabled = true,
    --             },
    --             quick_data = {
    --                 enabled = false,
    --             },
    --         })
    --     end,
    -- },

    -- Plugin for automated bullet lists in markdown
    -- use "dkarter/bullets.vim"

    -- Plugin to generate table of contents for Markdown files
    -- use "mzlogin/vim-markdown-toc"

    -- use "fladson/vim-kitty" -- get colors in kitty.conf

    -- preview markdown files in browser
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_close = 0 -- don't auto close current preview window when change to another buffer
            vim.g.mkdp_echo_preview_url = 1 -- echo preview page url in command line when open preview page
            vim.g.mkdp_filetypes = { "markdown" }
            -- Open preview in a new window
            vim.cmd([[
                function OpenMarkdownPreview(url)
                    execute "silent ! brave-browser --new-window " . a:url
                endfunction
                let g:mkdp_browserfunc = "OpenMarkdownPreview"
            ]])
        end,
        enabled = vim.fn.executable("npm") == 1,
    },

    -- preview HTML, CSS and JS in browser
    {
        "turbio/bracey.vim",
        build = "npm install --prefix server",
        ft = "html",
        cmd = "Bracey",
        keys = {
            { "<leader>mb", "<cmd>Bracey<cr>", desc = "Open Preview (Live Server)" },
        },
        config = function()
            -- Open preview in a new window
            vim.g.bracey_browser_command = "brave-browser --new-window"
        end,
        enabled = vim.fn.executable("npm") == 1,
    },

    -- preview colors in neovim
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        -- keys = {
        --     { "<leader>cr",  "<cmd>ColorizerReloadAllBuffers<cr>", desc = "ColorizeReload" },
        -- },
        config = function()
            require("colorizer").setup({
                filetypes = { "*" },
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
        keys = {
            { "<M-c>", "<cmd>VCoolor<cr>", desc = "Open Colorpicker", mode = { "n", "i" } },
        },
        config = function()
            vim.g.vcoolor_disable_mappings = 1
            -- vim.g.vcoolor_lowercase = 1
        end,
        enabled = vim.fn.executable("zenity") == 1 or vim.fn.executable("yad") == 1,
    },

    -- LaTeX support
    -- {
    --     "lervag/vimtex",
    --     -- event = "VeryLazy",
    --     init = function()
    --         vim.g.vimtex_view_method = 'zathura'
    --         vim.g.vimtex_syntax_enabled = 0 -- I use treesitter
    --         -- vim.g.vimtex_compiler_method = 'latexmk'
    --     end,
    --     enabled = vim.fn.executable("latexmk") == 1,
    -- },

    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },

    -- If I use leap someday
    -- makes some plugins dot-repeatable like leap
    ---{ "tpope/vim-repeat", event = "VeryLazy" },
}
