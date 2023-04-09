return {
    -- the colorscheme should be available when starting Neovim
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        enabled = CONFIG.ui.colorscheme == "tokyonight",
        opts = {
            style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            transparent = false, -- Enable this to disable setting the background color
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = CONFIG.ui.italic_comments },
                keywords = { italic = true },
                functions = {},
                variables = {},
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark", -- style for sidebars, see below
                floats = "dark", -- style for floating windows
            },
            sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false, -- dims inactive windows
            lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            -- load the colorscheme here
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "catppuccin",
        opts = {
            -- flavour = "frappe", -- mocha, frappe, macchiato, latte
            transparent_background = false,
            styles = {
                comments = CONFIG.ui.italic_comments and { 'italic' } or {},
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = false,
                telescope = true,
                notify = true,
                mini = false,
                treesitter = true,
                treesitter_context = true,
                markdown = true,
                hop = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "kanagawa",
        opts = {
            theme = "wave", -- wave, dragon, lotus
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd.colorscheme("kanagawa")
        end,
    },

    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "nightfox",
        opts = {
            transparent = false, -- Disable setting background
            dim_inactive = false, -- Non focused panes set to alternative background
        },
        config = function(_, opts)
            require("nightfox").setup(opts)
            vim.cmd.colorscheme("nightfox")
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "rose-pine",
        opts = {
            --- @usage 'auto'|'main'|'moon'|'dawn'
            variant = "auto",
            --- @usage 'main'|'moon'|'dawn'
            dark_variant = "main",
            -- Change specific vim highlight groups
            highlight_groups = {
                -- ColorColumn = { bg = "rose" },
                ColorColumn = { bg = "overlay" },
            },
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "sonokai",
        config = function()
            vim.g.sonokai_style = "andromeda" -- options: 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
            vim.g.sonokai_better_performance = 1 -- options: 0, 1
            vim.cmd.colorscheme("sonokai")
        end,
    },

    {
        "sam4llis/nvim-tundra",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "tundra",
        opts = {
            transparent_background = false,
            dim_inactive_windows = {
                enabled = false,
                color = nil,
            },
            -- editor = {
            --     search = {},
            --     substitute = {},
            -- },
            syntax = {
                booleans = { bold = true, italic = true },
                comments = { bold = true, italic = CONFIG.ui.italic_comments },
                conditionals = {},
                constants = { bold = true },
                fields = {},
                functions = {},
                keywords = {},
                loops = {},
                numbers = { bold = true },
                operators = { bold = true },
                punctuation = {},
                strings = {},
                types = { italic = true },
            },
            -- diagnostics = {
            --     errors = {},
            --     warnings = {},
            --     information = {},
            --     hints = {},
            -- },
            -- plugins = {
            --     lsp = true,
            --     treesitter = true,
            --     telescope = true,
            --     nvimtree = false,
            --     cmp = true,
            --     context = true,
            --     dbui = false,
            --     gitsigns = true,
            --     neogit = true,
            -- },
            -- overwrite = {
            --     colors = {},
            --     highlights = {},
            -- },
        },
        config = function(_, opts)
            require("nvim-tundra").setup(opts)
            vim.cmd.colorscheme("tundra")
        end,
    },

    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "vscode",
        opts = {
            transparent = false,
            italic_comments = CONFIG.ui.italic_comment,
            disable_nvimtree_bg = true,
            color_overrides = {},
            group_overrides = {},
        },
        config = function(_, opts)
            require("vscode").setup(opts)
            vim.cmd.colorscheme("vscode")
        end,
    },

    {
        "glepnir/zephyr-nvim",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "zephyr",
        config = function()
            vim.cmd.colorscheme("zephyr")
        end,
    },

    {
        "getomni/neovim",
        lazy = false,
        priority = 1000,
        enabled = CONFIG.ui.colorscheme == "omni",
        config = function()
            vim.cmd.colorscheme("omni")
        end,
    },
}
