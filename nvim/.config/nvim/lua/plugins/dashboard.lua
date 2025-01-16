local Util = require("core.util")
local Icons = require("core.icons")

-- Alternative: https://www.lazyvim.org/plugins/ui#snacksnvim-1
return {
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
            if vim.g.neovide == true then
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
}
