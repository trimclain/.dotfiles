return {

    -- auto remove search highlight and rehighlight when using n or N
    -- {
    --     "nvimdev/hlsearch.nvim",
    --     config = true,
    -- },

    -- better `vim.notify()`
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader><space>",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Delete all Notifications",
            },
            { "<leader>ns", "<cmd>Notifications<cr>", desc = "Show all Notifications" },
        },
        opts = {
            timeout = 1500,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            -- used for 100% transparency (NotifyBackground links to Normal, which is not defined when transparency is enabled)
            background_colour = CONFIG.ui.transparent_background and "#1e1e2e" or "NotifyBackground",
        },
        init = function()
            -- when noice is not enabled, install notify on VeryLazy
            local Util = require("core.util")
            if not Util.has_plugin("noice.nvim") then
                Util.on_very_lazy(function()
                    vim.notify = require("notify")
                end)
            end
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = { "BufNewFile", "BufReadPre" },
        -- keys = {
        --   { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
        --   { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
        -- },
        opts = {
            options = {
                show_close_icon = false, --default: true
                separator_style = CONFIG.ui.transparent_background and "thin" or "slant", -- | "thick" | "slant" | default: "thin" | "padded_slant"  | { 'any', 'any' }
                -- enforce_regular_tabs = true, -- default: false
                max_name_length = 30, -- default 18
                max_prefix_length = 30, -- prefix used when a buffer is de-duplicated, default 15
                tab_size = 21, -- default 18
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-Tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            if CONFIG.ui.colorscheme == "catppuccin" then
                opts = vim.tbl_extend("force", opts, {
                    highlights = require("catppuccin.groups.integrations.bufferline").get(),
                })
            end
            require("bufferline").setup(opts)
        end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            -----------------------------------------------------------------------------------------------------------
            -- Conditions to disable sections
            -----------------------------------------------------------------------------------------------------------
            -- Don't show a section when vim has less than 80 columns
            local hide_in_width = function()
                return vim.o.columns > 80
            end

            -- Don't show a section in ui filetypes
            local show_lsp_section = function()
                local buf_ft = vim.bo.filetype
                local ui_filetypes = {
                    "help",
                    "undotree",
                    "lspinfo",
                    "mason",
                    "null-ls-info",
                    "NeogitStatus",
                    "NeogitCommitMessage",
                    "spectre_panel",
                    "TelescopePrompt",
                    "Trouble",
                    "DressingSelect",
                    "",
                }
                if vim.tbl_contains(ui_filetypes, buf_ft) then
                    return false
                end
                return true
            end

            -----------------------------------------------------------------------------------------------------------
            -- LSP and Formatters
            -----------------------------------------------------------------------------------------------------------
            -- Get the list of active lsp servers
            local function lsp_list()
                local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
                local buf_client_names = {}

                for _, client in pairs(buf_clients) do
                    if client.name ~= "null-ls" then
                        table.insert(buf_client_names, client.name)
                    end
                end

                return table.concat(buf_client_names, ", ")
            end

            -- Get the list of active formatters and linters
            local function formatters_list()
                local buf_ft = vim.bo.filetype
                local nls_sources = require("null-ls.sources")
                local available_sources = nls_sources.get_available(buf_ft)
                local registered = {}
                for _, source in ipairs(available_sources) do
                    for method in pairs(source.methods) do
                        registered[method] = registered[method] or {}
                        table.insert(registered[method], source.name)
                    end
                end
                local formatter_names = {}
                local formatter = registered["NULL_LS_FORMATTING"]
                local linter = registered["NULL_LS_DIAGNOSTICS"]
                if formatter ~= nil then
                    vim.list_extend(formatter_names, formatter)
                end
                if linter ~= nil then
                    -- handle the case where I use the same tool for formatting and linting
                    if not vim.tbl_contains(formatter_names, linter[1]) then
                        vim.list_extend(formatter_names, linter)
                    end
                end
                return table.concat(formatter_names, ", ")
            end

            local lsp_servers = {
                function()
                    local lsp = lsp_list()
                    local text = " LSP:"
                    if lsp == "" then
                        -- return " ∅"
                        return "%#WinSeparator#  LSP %*"
                    end
                    return vim.fn.join({ text, lsp, "" }, " ")
                end,
                cond = function()
                    return hide_in_width() and show_lsp_section()
                end,
                padding = { right = 0 },
                -- Alternate: dont show when empty
                -- draw_empty = false,
                component_separators = "",
            }

            local formatters = {
                function()
                    local formatters = formatters_list()
                    local text = " Style:"
                    if formatters == "" then
                        -- return " ∅"
                        return "%#WinSeparator#  Style %*"
                    end
                    return vim.fn.join({ "", text, formatters }, " ")
                end,
                cond = function()
                    return hide_in_width() and show_lsp_section()
                end,
                padding = { right = 0 },
            }

            -----------------------------------------------------------------------------------------------------------
            -- Custom Mode Component
            -----------------------------------------------------------------------------------------------------------
            local mode = function()
                -- stylua: ignore
                local modes = {
                    ['n']      = 'NORMAL',
                    ['no']     = 'O-PENDING',
                    ['nov']    = 'O-PENDING',
                    ['noV']    = 'O-PENDING',
                    ['no\22']  = 'O-PENDING',
                    ['niI']    = 'NORMAL',
                    ['niR']    = 'NORMAL',
                    ['niV']    = 'NORMAL',
                    ['nt']     = 'NORMAL',
                    ['ntT']    = 'NORMAL',
                    ['v']      = 'VISUAL',
                    ['vs']     = 'VISUAL',
                    ['V']      = 'V-LINE',
                    ['Vs']     = 'V-LINE',
                    ['\22']   = 'V-BLOCK',
                    ['\22s']  = 'V-BLOCK',
                    ['s']      = 'SELECT',
                    ['S']      = 'S-LINE',
                    ['\19']   = 'S-BLOCK',
                    ['i']      = 'INSERT',
                    ['ic']     = 'INSERT',
                    ['ix']     = 'INSERT',
                    ['R']      = 'REPLACE',
                    ['Rc']     = 'REPLACE',
                    ['Rx']     = 'REPLACE',
                    ['Rv']     = 'V-REPLACE',
                    ['Rvc']    = 'V-REPLACE',
                    ['Rvx']    = 'V-REPLACE',
                    ['c']      = 'COMMAND',
                    ['cv']     = 'EX',
                    ['ce']     = 'EX',
                    ['r']      = 'REPLACE',
                    ['rm']     = 'MORE',
                    ['r?']     = 'CONFIRM',
                    ['!']      = 'SHELL',
                    ['t']      = 'TERMINAL',
                }

                local m = vim.api.nvim_get_mode().mode
                return " " .. modes[m]
                -- return "󰀘"
            end

            -----------------------------------------------------------------------------------------------------------

            -- Show the size of tabs
            local spaces = function()
                return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
            end

            -- Show if formatting on save is enabled
            local autoformat = function()
                if CONFIG.lsp.format_on_save then
                    -- ""
                    return ""
                end
                -- "", ""
                return ""
            end

            -- Move next sections to the middle of the screen
            local move_to_the_middle = {
                function()
                    return "%="
                end,
                component_separators = "",
            }

            -----------------------------------------------------------------------------------------------------------

            local icons = require("core.icons")
            return {
                options = {
                    theme = "auto",
                    section_separators = { left = " ", right = "" },
                    component_separators = { left = "", right = "" },
                    -- block = { left = "█", right = "█" },

                    -- component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },

                    -- component_separators = { left = '', right = '' },
                    -- section_separators = { left = '', right = '' },
                    -- component_separators = { left = "|", right = "|", },
                    -- component_separators = { " ", " " },

                    -- component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                },
                sections = {
                    lualine_a = { mode },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = {
                                added = icons.git.Add,
                                modified = icons.git.Mod,
                                removed = icons.git.Remove,
                            },
                        },
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                    },
                    lualine_c = {
                        move_to_the_middle,
                        lsp_servers,
                        formatters,
                    },
                    lualine_x = { "encoding", spaces, "fileformat", "filetype" },
                    lualine_y = {},
                    lualine_z = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                -- TODO with noice.nvim:
                -- sections = {
                --     lualine_x = {
                --         -- stylua: ignore
                --         {
                --             function() return require("noice").api.status.command.get() end,
                --             cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                --             color = fg("Statement")
                --         },
                --         -- stylua: ignore
                --         {
                --             function() return require("noice").api.status.mode.get() end,
                --             cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                --             color = fg("Constant") ,
                --         },
                --         {
                --             require("lazy.status").updates,
                --             cond = require("lazy.status").has_updates,
                --             color = fg("Special"),
                --         },
                --     },
                -- },
                extensions = { "lazy", "neo-tree", "quickfix", "toggleterm" },
            }
        end,
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            -- Next lines add the ↲ sign at the EOL
            vim.opt.list = true
            -- vim.opt.listchars:append "space:⋅"
            -- vim.opt.listchars:append "space:"
            -- vim.opt.listchars:append ("eol:↴")
            -- vim.opt.listchars:append ("eol:﬋")
            -- vim.opt.listchars:append ("eol:⤶")
            vim.opt.listchars:append("eol:↲")
            -- To set or unset the char for a trailing space (default is "trail:-")
            vim.opt.listchars:append("trail: ") -- currently it's unset
            return {
                char = "▏",
                -- char = "│",
                filetype_exclude = {
                    "help",
                    "man",
                    "checkhealth",
                    "lazy",
                    "lspinfo",
                    "neo-tree",
                    "neogitstatus",
                    "undotree",
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "mason",
                },
                show_trailing_blankline_indent = false,
                show_current_context = false,
                show_end_of_line = true,
            }
        end,
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "▏",
            -- symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },

    -- foldcolumn
    -- { "kevinhwang91/nvim-ufo" },

    -- SOMEDAY: in case I want to replace the command line with a ui
    -- noicer ui
    -- NOTE: this plugin includes fidget.nvim
    -- {
    --   "folke/noice.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     lsp = {
    --       override = {
    --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --         ["vim.lsp.util.stylize_markdown"] = true,
    --       },
    --     },
    --     presets = {
    --       bottom_search = true,
    --       command_palette = true,
    --       long_message_to_split = true,
    --     },
    --   },
    --   -- stylua: ignore
    --   keys = {
    --     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    --     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    --     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    --     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    --     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
    --     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    --   },
    -- },

    -- dashboard
    {
        "goolord/alpha-nvim",
        enabled = CONFIG.ui.dashboard,
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }

            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":lua require('core.util').telescope('files')()<CR>"),
                -- dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles<CR>"),
                dashboard.button("s", " " .. " Find string", ":Telescope live_grep<CR>"),
                dashboard.button("t", "󰄵 " .. " Find todos", ":TodoTelescope keywords=TODO,FIX<CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC | cd ~/.config/nvim<CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            -- Disabled: adds 12-15 ms to startup time
            -- Show git status if in git repo
            -- if require("core.util").in_git_worktree() then
            --     table.insert(
            --         dashboard.section.buttons.val,
            --         5,
            --         dashboard.button("g", " " .. " Git status", ":Neogit<CR>")
            --     )
            -- end

            -- Since I don't have tmux in neovide, add a project manager to dashboard
            if vim.g.neovide ~= nil then
                table.insert(
                    dashboard.section.buttons.val,
                    2,
                    dashboard.button("p", " " .. " Open project", ":lua require('core.util').open_project()<CR>")
                )
            end

            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            -- dashboard.section.header.opts.hl = "AlphaHeader"
            -- dashboard.section.buttons.opts.hl = "AlphaButtons"
            -- dashboard.section.footer.opts.hl = "AlphaFooter"

            dashboard.config.layout[1].val = vim.fn.max({ 3, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) -- logo top margin
            dashboard.config.layout[3].val = 2 -- distance between logo and buttons

            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded "
                        .. stats.count
                        .. " plugins   in "
                        .. ms
                        .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },

    -- UI for nvim-lsp's progress handler (loading animation at startup on bottom right)
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        tag = "legacy",
        opts = {
            text = {
                spinner = CONFIG.ui.spinner,
            },
            window = {
                relative = "editor", -- where to anchor, either "win" or "editor" (default: "win")
                blend = CONFIG.ui.transparent_background and 0 or 100, -- &winblend for the window (default: 100)
            },
        },
    },

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ui components
    { "MunifTanjim/nui.nvim", lazy = true },
}
