local Icons = require("core.icons").ui

return {

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = {
                marks = false, -- shows a list of your marks on ' and `
                registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                presets = {
                    operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                    motions = false, -- adds help for motions
                    text_objects = false, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            -- key_labels = {
            --     -- ["<space>"] = "SPC",
            --     ["<leader>"] = "Space",
            --     -- ["<cr>"] = "RET",
            --     -- ["<tab>"] = "TAB",
            -- },
            window = {
                border = CONFIG.ui.border,
            },
            layout = {
                align = "center", -- align columns left, center or right
            },
            show_help = false, -- show help message on the command line when the popup is visible
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            local nkeymaps = {
                mode = { "n" },
                ["g"] = { name = "+goto" },
                -- ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                -- ["<leader><tab>"] = { name = "+tabs" },
                -- ["<leader>b"] = { name = "+buffer" },
                ["<leader>d"] = { name = "+document" },
                ["<leader>f"] = { name = "+find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" }, -- FIX:
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>m"] = { name = "+make" },
                ["<leader>n"] = { name = "+neorg/neotest" },
                ["<leader>o"] = { name = "+options" },
                ["<leader>p"] = { name = "+plugins" },
                ["<leader>r"] = { name = "+replace/refactor" },
                ["<leader>s"] = { name = "+splitjoin" },
                ["<leader>t"] = { name = "+tab/terminal" },
                -- ["<leader>h"] = { name = "+tbd" },
                -- ["<leader>j"] = { name = "+tbd" },
                -- ["<leader>k"] = { name = "+tbd" },
                -- ["<leader>v"] = { name = "+tbd" },
                -- ["<leader>x"] = { name = "+tbd" },
                -- ["<leader>c"] = { name = "+tbd" },
            }
            -- if Util.has_plugin("noice.nvim") then
            --   nkeymaps["<leader>sn"] = { name = "+noice" }
            -- end
            local vkeymaps = {
                mode = { "v" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" }, -- FIX:
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>r"] = { name = "+refactor" },
            }
            wk.register(nkeymaps)
            wk.register(vkeymaps)
        end,
    },

    -- terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "VeryLazy",
        opts = {
            open_mapping = [[<c-\>]],
            -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            shading_factor = 2,
            direction = "float",
            float_opts = {
                border = "curved",
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            -- set terminal keymaps
            function _G.set_terminal_keymaps()
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = 0 })
            end
            vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

            -- Custom Terminals
            local function open_in_toggleterm(cmd)
                return require("toggleterm.terminal").Terminal:new({ cmd = cmd, hidden = true })
            end

            -- Node
            local node = open_in_toggleterm("node")
            function _NODE_TOGGLE()
                node:toggle()
            end
            vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", { desc = "Open Node in Terminal" })

            -- Python3
            local python = open_in_toggleterm("python3")
            function _PYTHON_TOGGLE()
                python:toggle()
            end
            vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { desc = "Open Python in Terminal" })

            -- Htop
            local htop = open_in_toggleterm("htop")
            function _HTOP_TOGGLE()
                htop:toggle()
            end
            vim.keymap.set("n", "<leader>th", "<cmd>lua _HTOP_TOGGLE()<cr>", { desc = "Open HTOP in Terminal" })

            -- Lazygit
            -- local lazygit = open_in_toggleterm("lazygit")
            -- function _LAZYGIT_TOGGLE()
            --     lazygit:toggle()
            -- end
            -- vim.keymap.set("n", "<leader>gs", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", { desc = "Open Lazygit in Terminal" })
        end,
    },

    -- undotree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
        },
    },

    -- search/replace in multiple files
    {
        "nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
      { "<leader>rw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Replace Word (Spectre)" },
      { "<leader>rf", function() require("spectre").open_file_search() end, desc = "Replace Buffer (Spectre)" },
    },
    },

    -- git client
    {
        "NeogitOrg/neogit",
        -- dir = "~/projects/open-source/nvim-plugins/neogit",
        -- https://github.com/NeogitOrg/neogit/tree/68a3e90e9d1ed9e362317817851d0f34b19e426b?tab=readme-ov-file#configuration
        commit = "68a3e90", -- pin until it's fixed
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        -- TODO: https://superuser.com/questions/887712/how-do-i-change-the-hilighted-length-of-git-commit-messages-in-vim
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                disable_commit_confirmation = true, -- config relevant for pinned commit
                disable_insert_on_commit = true, -- "auto", "true" or "false"
                -- Change the default way of opening neogit
                kind = "tab", -- "tab", "split", "split_above", "vsplit", "floating"
                -- The time after which an output console is shown for slow running commands
                --console_timeout = 2000,
                -- Automatically show console if a command takes more than console_timeout milliseconds
                --auto_show_console = true,
                -- override/add mappings
                -- commit_editor = {
                commit_popup = { -- config relevant for pinned commit
                    kind = "split", -- default: "auto"
                },
                signs = {
                    -- { CLOSED, OPENED }
                    section = { Icons.ArrowClosed, Icons.ArrowOpen }, -- default: { ">", "v" },
                    item = { Icons.ArrowClosedSmall, Icons.ArrowOpenSmall }, -- default: { ">", "v" },
                    -- hunk = { "", "" },
                    hunk = { "", "" },
                },
                mappings = {
                    -- popup = {
                    status = { -- config relevant for pinned commit
                        ["P"] = "PullPopup",
                        ["p"] = "PushPopup",
                    },
                },
            })

            -- Close Neogit after `git push`
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeogitPushComplete",
                group = vim.api.nvim_create_augroup("trimclain_close_neogit_after_push", { clear = true }),
                callback = function()
                    neogit.close()
                end,
            })
        end,
    },

    -- better git diff
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
        keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signcolumn = CONFIG.git.show_signcolumn, -- Toggle with `:Gitsigns toggle_signs`
            current_line_blame = CONFIG.git.show_blame, -- Toggle with `:Gitsigns toggle_current_line_blame`
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- Navigation
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")

                -- Actions
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                -- stylua: ignore start
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                -- stylua: ignore end

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },

    -- buffer remove (other options: https://github.com/famiu/bufdelete.nvim)
    {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
        },
    },

    -- TODO: someday
    -- better diagnostics list and others
    -- {
    --     "folke/trouble.nvim",
    --     cmd = { "TroubleToggle", "Trouble" },
    --     opts = { use_diagnostic_signs = true },
    --     keys = {
    --         { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    --         { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    --         { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    --         { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    --         {
    --             "[q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").previous({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cprev()
    --                 end
    --             end,
    --             desc = "Previous trouble/quickfix item",
    --         },
    --         {
    --             "]q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").next({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cnext()
    --                 end
    --             end,
    --             desc = "Next trouble/quickfix item",
    --         },
    --     },
    -- },

    -- todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "Todo" }
            -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = Icons.Bug, -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = Icons.Check, color = "info" },
                HACK = { icon = Icons.Fire, color = "warning" },
                WARN = {
                    icon = require("core.icons").diagnostics.BoldWarn,
                    color = "warning",
                    alt = { "WARNING", "XXX" },
                },
                PERF = { icon = Icons.Clock, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = Icons.Message, color = "hint", alt = { "INFO", "IDEA" } },
                TEST = { icon = Icons.Speedometer, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- search hidden files/directories
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        },
    },

    -- smooth scrolling
    -- althernative: https://github.com/declancm/cinnamon.nvim
    {
        "karb94/neoscroll.nvim",
        cond = CONFIG.ui.neoscroll,
        event = { "BufReadPost" },
        opts = {
            -- All these keys will be mapped to their corresponding default scrolling animation
            -- mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
            mappings = {},
            stop_eof = false, -- Stop at <EOF> when scrolling downwards (default: true)
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            easing_function = "sine", -- Default easing function; options: quadratic, cubic, quartic, quintic, circular, sine
        },
        config = function(_, opts)
            require("neoscroll").setup(opts)
            local t = {}
            -- Syntax: t[keys] = {function, {function arguments}}
            -- Use the "sine" easing function
            t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "50" } }
            t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "50" } }
            -- Use the "circular" easing function
            -- t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
            -- t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
            -- Pass "nil" to disable the easing animation (constant scrolling speed)
            -- t['<C-y>'] = {'scroll', {'-0.10', 'false', '100', nil}}
            -- t['<C-e>'] = {'scroll', { '0.10', 'false', '100', nil}}
            -- When no easing function is provided the default easing function (in this case "quadratic") will be used
            t["zt"] = { "zt", { "100" } }
            t["zz"] = { "zz", { "100" } }
            t["zb"] = { "zb", { "100" } }
            require("neoscroll.config").set_mappings(t)
        end,
    },

    -- easier jumps with f,F,t,T
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            label = {
                rainbow = {
                    enabled = false,
                },
            },
            modes = {
                char = {
                    jump_labels = true,
                    multi_line = false,
                    highlight = { backdrop = false },
                },
            },
        },
    },

    -- harpoon btw
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        -- dir = "~/projects/open-source/nvim-plugins/harpoon",
        -- stylua: ignore
        keys = function()
            local harpoon = require("harpoon")
            return {
                { "<leader>a", function() harpoon:list():add() end, desc = "Add Harpoon Mark" },
                { "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Toggle Harpoon Menu" },
                { "<C-j>", function() harpoon:list():select(1) end, desc = "Harpoon to file 1" },
                { "<C-k>", function() harpoon:list():select(2) end, desc = "Harpoon to file 2" },
                { "<C-h>", function() harpoon:list():select(3) end, desc = "Harpoon to file 3" },
                { "<C-g>", function() harpoon:list():select(4) end, desc = "Harpoon to file 4" },
            }
        end,
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            require("harpoon"):setup(opts)
        end,
    },

    -- zen mode
    {
        "folke/zen-mode.nvim",
        -- dependencies = {
        --     -- twilight
        --     {
        --         "folke/twilight.nvim",
        --         opts = {
        --             alpha = 0.25, -- amount of dimming
        --         },
        --     },
        -- },
        cmd = "ZenMode",
        -- stylua: ignore
        keys = {
            { "<leader>z", function() require("zen-mode").toggle() end, desc = "Toggle Zen Mode" }
        },
        opts = {
            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = false,
                font = "+4", -- font size increment
            },
        },
    },

    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other
    -- instances.
    {
        "RRethy/vim-illuminate",
        cond = CONFIG.ui.illuminate,
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            vim.keymap.set("n", "<leader>oi", function()
                require("illuminate").toggle()
            end, { desc = "Toggle Vim [I]lluminate" })

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })

            -- replace underline with highlight (no need since astrotheme supports this now)
            -- local hl = vim.api.nvim_set_hl
            -- local color = "#31363d" -- color taken from primer.nvim
            -- hl(0, "IlluminatedWordRead", { fg = "NONE", bg = color })
            -- hl(0, "IlluminatedWordWrite", { fg = "NONE", bg = color })
            -- hl(0, "IlluminatedWordText", { fg = "NONE", bg = color })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-sleuth" },

    -- auto remove search highlight and rehighlight when using n or N
    -- {
    --     "nvimdev/hlsearch.nvim",
    --     config = true,
    -- },

    -- incsearch for :linenum<cr>
    -- {
    --     "nacro90/numb.nvim",
    --     event = "BufReadPost",
    --     config = true,
    -- },
}
