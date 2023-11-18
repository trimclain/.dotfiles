local Util = require("core.util")

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
    -- {
    --     "tweekmonster/startuptime.vim",
    --     cmd = "StartupTime",
    -- },

    -- TODO:?
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

    -- TODO:?
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

    -- run/build files
    {
        "trimclain/builder.nvim",
        dev = true,
        cmd = "Build",
        -- stylua: ignore
        keys = {
            {"<C-b>", function() require("builder").build() end, desc = "Build current buffer"},
        },
        opts = {
            type = CONFIG.ui.builder_type,
            float_border = CONFIG.ui.border,
            commands = {
                c = "gcc % -o $basename.out && ./$basename.out",
                -- cpp = "g++ % -o $basename.out && ./$basename.out",
                go = "go run %",
                -- go = "go build % && ./$basename",
                -- java = "java %",
                -- javascript = "node %",
                -- julia = "julia %",
                -- lua = "lua %", -- this will override the `enable_builtin` for lua
                -- markdown = "glow %",
                python = "python %",
                -- rust = "cargo run",
                sh = "sh %",
                -- tex = "tectonic --chatter=minimal %",
                -- typescript = "ts-node %",
                zsh = "zsh %",
            },
        },
    },

    -- advanced note taking, project/task management
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        ft = "norg",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neorg").setup({
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = { -- Adds pretty icons to your documents
                        config = {
                            icon_preset = "basic", -- "basic" (default), "diamond", "varied"
                        },
                    },
                    -- ["core.dirman"] = { -- Manages Neorg workspaces
                    --     config = {
                    --         workspaces = {
                    --             notes = "~/notes",
                    --         },
                    --     },
                    -- },
                    -- https://github.com/nvim-neorg/neorg/wiki/Completion#configuration
                    -- ["core.completion"] = {
                    --     config = { engine = "nvim-cmp" },
                    -- },
                },
            })

            vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", { desc = "Toggle Neorg Concealer" })
        end,
    },

    -- TODO: find out how to make plenary work
    -- run tests
    {
        "nvim-neotest/neotest",
        cond = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
        },
        -- stylua: ignore
        -- keys = {
        --     { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest Run File" },
        --     { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Neotest Run All Test Files" },
        --     { "<leader>tr", function() require("neotest").run.run() end, desc = "Neotest Run Nearest" },
        --     { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Neotest Toggle Summary" },
        --     -- { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Neotest Show Output" },
        --     { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Neotest Toggle Output Panel" },
        --     { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
        -- },
        opts = {
            adapters = {
                ["neotest-plenary"] = { min_init = "./tests/init.lua" },
                -- ["neotest-plenary"] = {},
            },
        },
    },

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

    -- TODO:?
    -- Plugin for automated bullet lists in markdown
    -- use "dkarter/bullets.vim"

    -- TODO:?
    -- Plugin to generate table of contents for Markdown files
    -- use "mzlogin/vim-markdown-toc"

    -- preview markdown files in browser
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npx --yes yarn install", -- Lazy sync doesn't run `git restore .` so it can't pull
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_close = 0 -- don't auto close current preview window when change to another buffer
            vim.g.mkdp_echo_preview_url = 1 -- echo preview page url in command line when open preview page
            vim.g.mkdp_filetypes = { "markdown" }

            -- Detect installed browser
            local browserlist = {
                "thorium-browser",
                "google-chrome",
                "brave",
                "brave-browser",
            }
            for _, browser in ipairs(browserlist) do
                if vim.fn.executable(browser) == 1 then
                    vim.g.mkdp_browser = browser
                    break
                end
            end

            -- Open preview in a new window
            -- doesn't work on mac: https://github.com/iamcco/markdown-preview.nvim#faq
            vim.cmd([[
                function OpenMarkdownPreview(url)
                    execute "silent ! " . g:mkdp_browser . " --new-window " . a:url
                endfunction
                let g:mkdp_browserfunc = "OpenMarkdownPreview"
            ]])
        end,
        enabled = vim.fn.executable("npm") == 1,
    },

    -- TODO: switch to this for markdown preview?
    -- -- markdown preview
    -- {
    --     "toppair/peek.nvim",
    --     build = "deno task --quiet build:fast",
    --     keys = {
    --         {
    --             "<leader>op",
    --             function()
    --                 local peek = require("peek")
    --                 if peek.is_open() then
    --                     peek.close()
    --                 else
    --                     peek.open()
    --                 end
    --             end,
    --             desc = "Peek (Markdown Preview)",
    --         },
    --     },
    --     opts = { theme = "light" },
    -- },

    -- preview HTML, CSS and JS in browser
    {
        "turbio/bracey.vim",
        build = "npm ci --prefix server", -- Lazy sync doesn't run `git restore .` so it can't pull.
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

    -- TODO:?
    -- -- color picker in neovim
    -- {
    --     "uga-rosa/ccc.nvim",
    -- },

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

    -- TODO:?
    -- For aligning tables
    -- { "godlygeek/tabular" }

    -- TODO:?
    -- makes some plugins dot-repeatable like flash.nvim
    ---{ "tpope/vim-repeat", event = "VeryLazy" },
}
