return {
    {
        "LunarVim/darkplus.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "darkplus",
        config = function()
            -- require("darkplus").setup()
            vim.cmd.colorscheme("darkplus")
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "catppuccin", -- `cond` is now the same as `enabled`, but skips clean
        opts = {
            -- flavour = "frappe", -- mocha, frappe, macchiato, latte
            transparent_background = CONFIG.ui.transparent_background,
            styles = {
                comments = CONFIG.ui.italic_comments and { "italic" } or {},
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
                ----
                cmp = true,
                gitsigns = true,
                nvimtree = false,
                telescope = true,
                notify = true,
                mini = false,
                ----
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
                ----
                dashboard = true,
                fidget = true,
                harpoon = true,
                hop = true,
                markdown = true,
                mason = true,
                neotree = true,
                neogit = true,
                -- noice = true,
                -- dap -- check out https://github.com/catppuccin/nvim#special-integrations
                -- lsp_troble = true,
                -- illuminate = true,
                which_key = true,
                treesitter = true,
                treesitter_context = false,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        cond = CONFIG.ui.colorscheme == "tokyonight",
        opts = {
            style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            transparent = false, -- Enable this to disable setting the background color
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = CONFIG.ui.italic_comments },
                keywords = { italic = CONFIG.ui.italic_comments },
                functions = {},
                variables = {},
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark", -- style for sidebars, see below
                floats = "dark", -- style for floating windows
            },
            sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false, -- dims inactive windows
            lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            -- load the colorscheme here
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "rose-pine",
        opts = {
            --- @usage 'auto'|'main'|'moon'|'dawn'
            variant = "auto",
            --- @usage 'main'|'moon'|'dawn'
            dark_variant = "moon",
            disable_italics = not CONFIG.ui.italic_comments,

            -- Change specific vim highlight groups
            -- https://github.com/rose-pine/neovim/wiki/Recipes
            -- https://rosepinetheme.com/palette
            highlight_groups = {
                -- make telescope.nvim transparent
                TelescopeBorder = { fg = "highlight_high", bg = "none" },
                TelescopeNormal = { bg = "none" },
                TelescopePromptNormal = { bg = "base" },
                TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                TelescopeSelection = { fg = "text", bg = "base" },
                TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
                -- -- borderless telescope.nvim
                -- TelescopeBorder = { fg = "overlay", bg = "overlay" },
                -- TelescopeNormal = { fg = "subtle", bg = "overlay" },
                -- TelescopeSelection = { fg = "text", bg = "highlight_med" },
                -- TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
                -- TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

                -- TelescopeTitle = { fg = "base", bg = "love" },
                -- TelescopePromptTitle = { fg = "base", bg = "pine" },
                -- TelescopePreviewTitle = { fg = "base", bg = "iris" },

                -- TelescopePromptNormal = { fg = "text", bg = "surface" },
                -- TelescopePromptBorder = { fg = "surface", bg = "surface" },
            },
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    {
        "sam4llis/nvim-tundra",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "tundra",
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
        "AstroNvim/astrotheme",
        -- dir = "~/projects/open-source/nvim-plugins/astrotheme",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "astrotheme",
        opts = {
            palette = "astrodark", -- String of the default palette to use when calling `:colorscheme astrotheme`
            style = {
                transparent = CONFIG.ui.transparent_background,
                inactive = false,
                -- border = CONFIG.ui.border ~= "none",
                border = false,
                title_invert = true,
                italic_comments = CONFIG.ui.italic_comments,
                simple_syntax_colors = true,
            },
            highlights = {
                global = {
                    modify_hl_groups = function(hl, c)
                        -- hl.NeogitDiffDelete = { fg = c.ui.base, bg = c.syntax.red }
                        -- hl.NeogitDiffDeleteHighlight = { fg = c.ui.base, bg = c.syntax.red }
                        -- hl.NeogitDiffAdd = { fg = c.ui.base, bg = c.syntax.green }
                        -- hl.NeogitDiffAddHighlight = { fg = c.ui.base, bg = c.syntax.green }
                        if CONFIG.ui.cursorline then
                            hl.IlluminatedWordText = { fg = c.none, bg = "#31363d" }
                            hl.IlluminatedWordRead = { fg = c.none, bg = "#31363d" }
                            hl.IlluminatedWordWrite = { fg = c.none, bg = "#31363d" }
                        end
                    end,
                },
            },
        },
        config = function(_, opts)
            require("astrotheme").setup(opts)
            vim.cmd.colorscheme("astrotheme")
        end,
    },

    {
        "LunarVim/primer.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "primer-dark",
        config = function()
            vim.cmd.colorscheme("primer_dark")
        end,
    },

    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "nightfox",
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
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "vscode",
        opts = {
            transparent = CONFIG.ui.transparent_background,
            italic_comments = CONFIG.ui.italic_comments,
        },
        config = function(_, opts)
            require("vscode").setup(opts)
            vim.cmd.colorscheme("vscode")
        end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "gruvbox",
        opts = {
            bold = false,
            italic = {
                strings = false,
                comments = CONFIG.ui.italic_comments,
            },
            contrast = "hard", -- "hard", "soft" or "" (default)
            transparent_mode = CONFIG.ui.transparent_background,
        },
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "github-dark",
        opts = {
            options = {
                transparent = CONFIG.ui.transparent_background,
                styles = { -- Style to be applied to different syntax groups
                    comments = CONFIG.ui.italic_comments and "italic" or "NONE",
                    functions = "NONE",
                    keywords = "NONE",
                    variables = "NONE",
                    conditionals = "NONE",
                    constants = "NONE",
                    numbers = "NONE",
                    operators = "NONE",
                    strings = "NONE",
                    types = "NONE",
                },
                modules = {
                    cmp = true,
                    dashboard = CONFIG.ui.dashboard,
                    fidget = true,
                    gitsigns = true,
                    indent_blankline = true,
                    neogit = true,
                    neotree = true,
                    notify = true,
                    telescope = true,
                    treesitter_context = true,
                    whichkey = true,
                },
            },
        },
        config = function(_, opts)
            require("github-theme").setup(opts)
            vim.cmd.colorscheme("github_dark_dimmed")
        end,
    },

    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "onedark",
        opts = {
            style = "darker", --"dark", "darker", "cool", "deep", "warm", "warmer" and "light"
            transparent = false, -- Show/hide background

            -- Change code style ---
            -- Options are italic, bold, underline, none
            -- You can configure multiple style with comma separated, For e.g., keywords = "italic,bold"
            code_style = {
                comments = CONFIG.ui.italic_comments and "italic" or "none",
                keywords = "none",
                functions = "none",
                strings = "none",
                variables = "none",
            },

            -- Plugins Config --
            diagnostics = {
                darker = true, -- darker colors for diagnostic
                undercurl = true, -- use undercurl instead of underline for diagnostics
                background = true, -- use background color for virtual text
            },
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            vim.cmd.colorscheme("onedark")
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "kanagawa",
        opts = {
            theme = "wave", -- wave, dragon, lotus
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd.colorscheme("kanagawa")
        end,
    },

    {
        "glepnir/zephyr-nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "zephyr",
        config = function()
            vim.cmd.colorscheme("zephyr")
        end,
    },

    {
        "embark-theme/vim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "embark",
        config = function()
            vim.cmd.colorscheme("embark")
        end,
    },

    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "sonokai",
        config = function()
            vim.g.sonokai_style = "andromeda" -- options: 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
            vim.g.sonokai_better_performance = 1 -- options: 0, 1
            vim.cmd.colorscheme("sonokai")
        end,
    },

    {
        "getomni/neovim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "omni",
        config = function()
            vim.cmd.colorscheme("omni")
        end,
    },
}
