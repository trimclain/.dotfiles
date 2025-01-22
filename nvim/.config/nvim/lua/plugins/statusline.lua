return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        cond = CONFIG.plugins.lualine,
        opts = function()
            local Icons = require("core.icons")

            -----------------------------------------------------------------------------------------------------------
            -- Conditions to disable sections
            -----------------------------------------------------------------------------------------------------------
            local hide_in_width = function(min_width)
                if min_width then
                    return vim.api.nvim_win_get_width(0) > min_width
                end
                return vim.api.nvim_win_get_width(0) > 80
            end

            local ui_filetypes = {
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

            local disable_for_ui_filetypes = function()
                return not vim.tbl_contains(ui_filetypes, vim.bo.filetype)
            end

            local disable_for_ui_and_help_filetypes = function()
                return not vim.tbl_contains(vim.tbl_extend("force", { "help" }, ui_filetypes), vim.bo.filetype)
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
                    return hide_in_width() and disable_for_ui_and_help_filetypes()
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
                    return hide_in_width() and disable_for_ui_and_help_filetypes()
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
                                added = Icons.git.Add .. " ",
                                modified = Icons.git.Mod .. " ",
                                removed = Icons.git.Remove .. " ",
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
                            cond = function()
                                return hide_in_width(100) and disable_for_ui_filetypes()
                            end,
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
}
