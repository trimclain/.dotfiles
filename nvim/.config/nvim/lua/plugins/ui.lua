local Util = require("core.util")
local Icons = require("core.icons")

return {

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
            -- { "<leader>ns", "<cmd>Notifications<cr>", desc = "Show all Notifications" },
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
            if not Util.has_plugin("noice.nvim") then
                Util.on_very_lazy(function()
                    vim.notify = require("notify")
                end)
            end
        end,
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = { "BufNewFile", "BufReadPre" },
        cond = CONFIG.ui.bufferline,
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
        cond = CONFIG.ui.lualine,
        opts = function()
            -----------------------------------------------------------------------------------------------------------
            -- Conditions to disable sections
            -----------------------------------------------------------------------------------------------------------
            -- Don't show a section when vim has less than 80 columns
            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            local hide_in_width_100 = function()
                return vim.fn.winwidth(0) > 100
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
                return not vim.tbl_contains(ui_filetypes, buf_ft)
            end

            -----------------------------------------------------------------------------------------------------------
            -- LSP and Formatters
            -----------------------------------------------------------------------------------------------------------

            -- Get the list of active lsp servers
            local function lsp_list()
                local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                local buf_client_names = {}

                for _, client in pairs(buf_clients) do
                    if client.name ~= "null-ls" and client.name ~= "copilot" then
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
                    local servers = lsp_list()
                    local label = " LSP:"
                    if servers == "" then
                        -- return " ∅"
                        return "%#WinSeparator#  LSP %*"
                    end
                    return vim.fn.join({ label, servers, "" }, " ")
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
                    local icon = Icons.ui.Paragraph
                    local label = icon .. "Style:"
                    if formatters == "" then
                        -- return icon .. "∅"
                        return "%#WinSeparator# " .. icon .. "Style %*"
                    end
                    return vim.fn.join({ "", label, formatters }, " ")
                end,
                cond = function()
                    return hide_in_width() and show_lsp_section()
                end,
                padding = { right = 0 },
            }

            -- Show github copilot status
            local copilot = {
                function()
                    local status = require("copilot.api").status.data.status
                    -- this usually means there's no internet connection, so disable the icon
                    -- vim.notify("Status: " .. status)
                    if status == "Warning" then
                        return ""
                    end

                    -- notify when it's a new status
                    local status_known = status == "Normal" or status == "InProgress" or status == "Warning"
                    if status ~= "" and not status_known then
                        vim.notify("WOOOW! Unknown status: " .. status, vim.log.levels.INFO, { title = "Copilot News" })
                    end

                    return Icons.kinds.Copilot -- .. (status or "")
                end,
                cond = function()
                    local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
                    return ok and hide_in_width() and #clients > 0
                end,
                color = { fg = "#6CC644" },
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
                return Icons.misc.Vim .. modes[m]
                -- return "󰀘"
            end

            -----------------------------------------------------------------------------------------------------------

            -- Show the size of tabs
            local spaces = {
                function()
                    return Icons.ui.Tab .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
                end,
                cond = hide_in_width,
            }

            -- Show if formatting on save is enabled
            local autoformat = function()
                if CONFIG.lsp.format_on_save then
                    -- ""
                    return Icons.ui.DoubleCheck
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
                            -- colored = CONFIG.ui.colorscheme ~= "primer-dark",
                            symbols = {
                                added = Icons.git.Add,
                                modified = Icons.git.Mod,
                                removed = Icons.git.Remove,
                            },
                            cond = hide_in_width,
                        },
                        {
                            "diagnostics",
                            -- colored = CONFIG.ui.colorscheme ~= "primer-dark",
                            sections = { "error", "warn" },
                            symbols = {
                                error = Icons.diagnostics.Error,
                                warn = Icons.diagnostics.Warn,
                                info = Icons.diagnostics.Info,
                                hint = Icons.diagnostics.Hint,
                            },
                            cond = hide_in_width,
                        },
                    },
                    lualine_c = {
                        move_to_the_middle,
                        -----------------------------------------------------------------------------------------------
                        {
                            "filename",
                            newfile_status = true,
                            -- 0: Just the filename (default),
                            -- 1: Relative path,
                            -- 2: Absolute path,
                            -- 3: Absolute path, with tilde as the home directory,
                            -- 4: Filename and parent dir, with tilde as the home directory
                            path = 3,
                            -- spaces to leave in the window for other components
                            shorting_target = math.floor(vim.go.columns * 0.8), -- (default: 40)
                            symbols = {
                                modified = Icons.ui.Circle, -- default: "[+]"
                                readonly = Icons.ui.Lock, -- default: "[-]"
                                unnamed = "", -- default: "[No Name]"
                                newfile = Icons.ui.NewFile, -- default: "[New]"
                            },
                            cond = hide_in_width_100,
                        },
                        -----------------------------------------------------------------------------------------------

                        -- lsp_servers,
                        -- formatters,
                    },
                    lualine_x = {
                        {
                            "encoding",
                            cond = hide_in_width,
                        },
                        spaces,
                        {
                            "fileformat",
                            cond = hide_in_width,
                        },
                        "filetype",
                    },
                    lualine_y = { copilot },
                    lualine_z = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                -- winbar = {
                --     lualine_a = {},
                --     lualine_b = {},
                --     lualine_c = { "filename" },
                --     lualine_x = {},
                --     lualine_y = {},
                --     lualine_z = {},
                -- },
                -- tabline = {
                --     lualine_a = { "buffers" },
                --     lualine_b = { "branch" },
                --     lualine_c = { "filename" },
                --     lualine_x = {},
                --     lualine_y = {},
                --     lualine_z = { "tabs" },
                -- },
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
                extensions = { "lazy", "man", "mason", "neo-tree", "quickfix", "toggleterm" }, -- "trouble", "nvim-dap-ui"
            }
        end,
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        -- for setting shiftwidth and tabstop automatically
        -- dependencies = "tpope/vim-sleuth",
        cond = CONFIG.ui.indentline,
        opts = {
            indent = {
                char = Icons.ui.LineLeft,
                -- char = "│",
                tab_char = Icons.ui.LineLeft,
                -- tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "lazy",
                    "mason",
                    "neo-tree",
                    "notify",
                    "neogitstatus",
                    "undotree",
                    "toggleterm",
                },
            },
        },
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        cond = CONFIG.ui.indentline,
        opts = {
            symbol = Icons.ui.LineLeft,
            -- symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    ---@diagnostic disable-next-line: inject-field
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
        "nvimdev/dashboard-nvim",
        enabled = CONFIG.ui.dashboard,
        event = "VimEnter",
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
        opts = function()
            local winheight = vim.fn.winheight(0)

            -- big screen winheight: 36
            local padding_top = vim.fn.max({ 3, vim.fn.floor(winheight * 0.15) })
            local padding_bot = 1

            -- small screen winheight
            if winheight == 24 then
                padding_top = 1
                padding_bot = 0
            end

            local max_width = 43

            local logo = {
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }
            logo = vim.list_extend(
                vim.list_extend(vim.split(string.rep("\n", padding_top), "\n"), logo),
                vim.split(string.rep("\n", padding_bot), "\n")
            )

            local opts = {
                theme = "doom",
                hide = {
                    -- this is taken care of by lualine
                    -- enabling this messes up the actual laststatus setting after loading a file
                    statusline = false,
                },
                config = {
                    header = logo,
                    -- stylua: ignore
                    center = {
                        { action = Util.telescope("files"),                                    desc = " Find file",       icon = Icons.ui.Search, key = "f" },
                        -- { action = "ene | startinsert",                                        desc = " New file",        icon = Icons.ui.File, key = "n" },
                        { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = Icons.ui.Files, key = "r" },
                        { action = "Telescope live_grep",                                      desc = " Find string",     icon = Icons.ui.List, key = "s" },
                        { action = "TodoTelescope keywords=TODO,FIX",                          desc = " Find todos",      icon = Icons.ui.BoxChecked, key = "t" },
                        { action = Util.config_files,                                          desc = " Config",          icon = Icons.ui.Gear, key = "c" },
                        { action = "Lazy",                                                     desc = " Lazy",            icon = Icons.ui.Lazy, key = "l" },
                        { action = "qa",                                                       desc = " Quit",            icon = Icons.ui.SignOut, key = "q" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return {
                            "⚡ Neovim loaded "
                                .. stats.loaded
                                .. "/"
                                .. stats.count
                                .. " plugins   in "
                                .. ms
                                .. "ms",
                        }
                    end,
                },
            }

            -- Disabled: adds 12-15 ms to startup time
            -- Show git status if in git repo
            -- if Util.in_git_worktree() then
            --     table.insert(
            --         opts.config.center,
            --         5,
            --         { action = "Neogit", desc = " Git status", icon = " ", key = "g" }
            --     )
            -- end

            -- Since I don't have tmux in neovide, add a project manager to dashboard
            if vim.g.neovide ~= nil then
                table.insert(
                    opts.config.center,
                    2,
                    { action = Util.open_project, desc = " Open project", icon = Icons.ui.GitFolder, key = "p" }
                )
            end

            -- configure width
            for _, button in ipairs(opts.config.center) do
                button.desc = button.desc .. string.rep(" ", max_width - #button.desc)
                button.key_format = "  %s"
            end

            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "DashboardLoaded",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            return opts
        end,
    },

    -- UI for nvim-lsp's progress handler (loading animation at startup on bottom right)
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy", -- TODO: update to later tag
        cond = CONFIG.ui.spinner,
        opts = {
            text = {
                spinner = CONFIG.ui.spinner_type,
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
