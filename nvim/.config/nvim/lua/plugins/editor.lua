local Util = require("core.util")

return {

    -- File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
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
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
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
            popup_border_style = CONFIG.ui.border,
            window = {
                position = "left",
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
                                require("core.util").system_open(node.path)
                                require("neo-tree.command").execute({ toggle = true })
                                break
                            end
                        end
                    end,
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        tag = "0.1.3",
        -- version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim", -- make telescope 20-200 times faster
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
                enabled = vim.fn.executable("make") == 1,
            },
            "nvim-lua/plenary.nvim",
        },
        keys = {
            -- find files
            { "<C-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
            {
                "<leader>ff",
                Util.telescope("files", { previewer = true }, "default"),
                desc = "Find Files with preview",
            },

            -- stylua: ignore
            { "<C-f>", function() Util.curr_buf_search() end, desc = "Fzf Buffer" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "String in Files" },
            -- { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word under cursor" },

            {
                "<leader>fd",
                Util.telescope(
                    "git_files",
                    -- Yup, why would $HOME on windows be $HOME and not $HOMEPATH or $USERPROFILE
                    {
                        cwd = vim.fn.has("win32") == 1 and Util.join(os.getenv("HOMEPATH"), "dotfiles")
                            or Util.join(os.getenv("HOME"), ".dotfiles"),
                        prompt_title = "Dotfiles",
                    }
                ),
                desc = "Dotfiles",
            },

            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
            { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlight Groups" },
            { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
            { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
            { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },

            -- stylua: ignore
            { "<leader>fc", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },

            -- git
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
            { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "commits" },

            -- search
            -- {
            --   "<leader>ss",
            --   Util.telescope("lsp_document_symbols", {
            --     symbols = {
            --       "Class",
            --       "Function",
            --       "Method",
            --       "Constructor",
            --       "Interface",
            --       "Module",
            --       "Struct",
            --       "Trait",
            --       "Field",
            --       "Property",
            --     },
            --   }),
            --   desc = "Goto Symbol",
            -- },
            -- {
            --   "<leader>sS",
            --   Util.telescope("lsp_workspace_symbols", {
            --     symbols = {
            --       "Class",
            --       "Function",
            --       "Method",
            --       "Constructor",
            --       "Interface",
            --       "Module",
            --       "Struct",
            --       "Trait",
            --       "Field",
            --       "Property",
            --     },
            --   }),
            --   desc = "Goto Symbol (Workspace)",
            -- },
        },
        opts = {
            defaults = {
                -- prompt_prefix = " ",
                prompt_prefix = " ",
                -- selection_caret = " ",
                selection_caret = "  ",
                border = CONFIG.ui.border ~= "none",
                set_env = { ["COLORTERM"] = "truecolor" }, -- default: nil
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- search hidden files/directories
                    "--smart-case",
                },
                file_ignore_patterns = { -- ignore these files and folders
                    ".git/",
                    "__pycache__/*",
                    "%.sqlite3",
                    "%.ipynb",
                    "node_modules/*",
                    "%.jpg",
                    "%.jpeg",
                    "%.png",
                    "%.svg",
                    "%.otf",
                    "%.ttf",
                    "%.webp",
                    ".github/",
                    ".idea/",
                    ".settings/",
                    ".vscode/",
                    "__pycache__/",
                    "node_modules/",
                    "%.pdb",
                    "%.dll",
                    "%.class",
                    "%.exe",
                    "%.cache",
                    "%.ico",
                    "%.pdf",
                    "%.docx",
                    "%.mp4",
                    "%.mkv",
                    "%.rar",
                    "%.zip",
                    "%.7z",
                    "%.tar",
                    "%.bz2",
                    "%.epub",
                    "%.flac",
                    "%.tar.gz",
                },
                mappings = {
                    i = {
                        -- Cycle search history
                        ["<C-j>"] = function(...)
                            return require("telescope.actions").cycle_history_next(...)
                        end,
                        ["<C-k>"] = function(...)
                            return require("telescope.actions").cycle_history_prev(...)
                        end,

                        -- Clear the promt instead of scrolling
                        ["<C-u>"] = false,

                        -- Scroll in the preview
                        ["<C-f>"] = function(...)
                            return require("telescope.actions").preview_scrolling_down(...)
                        end,
                        ["<C-b>"] = function(...)
                            return require("telescope.actions").preview_scrolling_up(...)
                        end,

                        -- If I use trouble someday
                        -- ["<c-t>"] = function(...)
                        --   return require("trouble.providers.telescope").open_with_trouble(...)
                        -- end,
                        -- ["<a-t>"] = function(...)
                        --   return require("trouble.providers.telescope").open_selected_with_trouble(...)
                        -- end,

                        -- keys from pressing <C-/>
                        ["<C-_>"] = function(...)
                            require("telescope.actions").which_key(...)
                        end,
                    },

                    n = {
                        -- thanks prime now I do it too
                        ["<C-c>"] = function(...)
                            return require("telescope.actions").close(...)
                        end,
                        ["q"] = function(...)
                            return require("telescope.actions").close(...)
                        end,

                        -- for Telescope Buffers
                        ["dd"] = function(...)
                            return require("telescope.actions").delete_buffer(...)
                        end,
                    },
                },
            },
            pickers = {
                find_files = {
                    previewer = false,
                    hidden = true,
                },
                -- live_grep = {
                --     vimgrep_arguments = {
                --         "rg",
                --         "--color=never",
                --         "--no-heading",
                --         "--with-filename",
                --         "--line-number",
                --         "--column",
                --         "--hidden", -- search hidden files/directories
                --         "--smart-case",
                --     },
                -- theme = "dropdown",
                -- previewer = false
                -- },
                git_files = {
                    previewer = false,
                    show_untracked = true,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    -- initial_mode = "insert" -- or "normal"
                },
                colorscheme = {
                    theme = "dropdown",
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
        },
    },

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
                ["<leader>f"] = { name = "+find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" }, -- FIX:
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>m"] = { name = "+make" },
                ["<leader>n"] = { name = "+neogen/notify" },
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
                ["<leader>l"] = { name = "+lsp" }, -- FIX:
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
            shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
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
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        opts = {
            disable_commit_confirmation = true,
            -- Change the default way of opening neogit
            kind = "tab", -- "tab", "split", "split_above", "vsplit", "floating"
            -- override/add mappings
            mappings = {
                -- modify status buffer mappings
                status = {
                    ["q"] = "Close",
                    ["1"] = "Depth1",
                    ["2"] = "Depth2",
                    ["3"] = "Depth3",
                    ["4"] = "Depth4",
                    ["<tab>"] = "Toggle",
                    -- ["="] = "Toggle", -- fugitive habbit
                    ["x"] = "Discard",
                    ["s"] = "Stage",
                    -- ["a"] = "StageUnstaged",
                    -- ["<c-s>"] = "StageAll",
                    ["u"] = "Unstage",
                    -- ["U"] = "UnstageStaged",
                    -- ["d"] = "DiffAtFile",
                    -- ["$"] = "CommandHistory",
                    -- ["<c-r>"] = "RefreshBuffer",
                    -- ["o"] = "GoToFile",
                    -- ["<enter>"] = "Toggle",
                    -- ["<c-v>"] = "VSplitOpen",
                    -- ["<c-x>"] = "SplitOpen",
                    -- ["<c-t>"] = "TabOpen",
                    ["?"] = "HelpPopup",
                    -- ["D"] = "DiffPopup",
                    ["P"] = "PullPopup",
                    -- ["r"] = "RebasePopup",
                    ["p"] = "PushPopup",
                    ["c"] = "CommitPopup",
                    ["L"] = "LogPopup",
                    -- ["Z"] = "StashPopup",
                    -- ["b"] = "BranchPopup",
                },
            },
        },
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
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO", "IDEA" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
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
                    enabled = true,
                },
            },
            modes = {
                search = {
                    -- enabled = false,
                    -- highlight = { backdrop = true },
                    jump = { history = true, register = true, nohlsearch = true },
                },
                char = {
                    jump_labels = true,
                    -- multi_line = false,
                    -- highlight = { backdrop = false },
                },
            },
        },
    },

    -- harpoon btw
    {
        "ThePrimeagen/harpoon",
        -- stylua: ignore
        keys = {
            { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Add Harpoon Mark" },
            { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon Menu" },
            { "<C-j>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon to file 1" },
            { "<C-k>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon to file 2" },
            { "<C-h>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon to file 3" },
            { "<C-g>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon to file 4" },
        },
        opts = {
            global_settings = {
                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = { "harpoon" },
            },
        },
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
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- TODO: ?
    -- auto remove search highlight and rehighlight when using n or N
    -- {
    --     "nvimdev/hlsearch.nvim",
    --     config = true,
    -- },

    -- TODO: ?
    -- incsearch for :linenum<cr>
    -- {
    --     "nacro90/numb.nvim",
    --     event = "BufReadPost",
    --     config = true,
    -- },
}
