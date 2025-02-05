-- file tree
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        branch = "v3.x",
        dependencies = {
            "plenary.nvim",
            "nvim-web-devicons",
            "nui.nvim",
        },
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({ toggle = true, reveal_force_cwd = true })
                end,
                desc = "Explorer NeoTree",
            },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            if vim.fn.argc() == 1 then
                ---@diagnostic disable-next-line: param-type-mismatch
                local stat = vim.uv.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = function()
            local Icons = require("core.icons").ui

            return {
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_hidden = false, -- for Windows
                    },
                    bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
                    follow_current_file = {
                        enabled = true,
                    },
                },
                popup_border_style = CONFIG.ui.border == "none" and "rounded" or CONFIG.ui.border,
                window = {
                    position = "float", -- left, right, float, current (like netrw)
                    width = 35,
                    mappings = {
                        ["<space>"] = "none",
                        ["w"] = "none",
                        ["<tab>"] = "open",
                        -- Open allowed filetypes with xdg-open
                        ["o"] = function(state)
                            local node = state.tree:get_node()
                            local ext = node.name:match("^.+(%..+)$")
                            local extensions = { ".pdf", ".jpg", ".jpeg", ".png", ".html" }
                            for _, extension in pairs(extensions) do
                                if ext == extension then
                                    -- vim.notify(
                                    --     "Opened " .. node.name,
                                    --     vim.log.levels.INFO,
                                    --     { title = "NeoTree: System Open Files" }
                                    -- )
                                    vim.ui.open(node.path)
                                    require("neo-tree.command").execute({ toggle = true })
                                    break
                                end
                            end
                        end,
                        -- Copy file name
                        ["y"] = function(state)
                            local node = state.tree:get_node()
                            vim.fn.setreg("+", node.name)
                        end,
                    },
                },
                default_component_configs = {
                    indent = {
                        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = Icons.ArrowClosedSmall,
                        expander_expanded = Icons.ArrowOpenSmall,
                        expander_highlight = "NeoTreeExpander",
                    },
                },
            }
        end,
    },
}
