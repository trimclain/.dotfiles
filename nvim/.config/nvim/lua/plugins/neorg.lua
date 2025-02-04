-- advanced note taking, project/task management
return {
    {
        "nvim-neorg/neorg",
        version = "*",
        ft = "norg",
        dependencies = {
            "nvim-treesitter",

            -- no need for luarocks, I'll do it myself
            "nui.nvim",
            "plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-neorg/lua-utils.nvim",
            "pysan3/pathlib.nvim",
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
                    ["core.keybinds"] = {
                        config = {
                            default_keybinds = false, -- I'll set them myself
                        },
                    },
                },
            })

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2

            vim.api.nvim_create_autocmd("Filetype", {
                pattern = "norg",
                callback = function(ev)
                    local nmap = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
                    end

                    -- Defaults Keybinds:
                    -- Wiki: https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds
                    -- Code: https://github.com/nvim-neorg/neorg/blob/bdb29ea3e069f827d31973bc942c18793ee9fa64/lua/neorg/modules/core/keybinds/module.lua
                    nmap("<leader>nc", "<cmd>Neorg toggle-concealer<cr>", "Neorg Toggle Concealer")
                    nmap("<C-s>", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", "Neorg Cycle Task")
                    nmap("<CR>", "<Plug>(neorg.esupports.hop.hop-link)", "Neorg Jump to Link")
                end,
            })
        end,
    },
}
