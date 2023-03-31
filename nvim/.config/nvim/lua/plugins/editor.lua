local Util = require("core.util")

return {

    -- File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = {
            -- {
            --   "<leader>fe",
            --   function()
            --     require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
            --   end,
            --   desc = "Explorer NeoTree (root dir)",
            -- },
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            -- { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
            -- { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            filesystem = {
                bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
                follow_current_file = true,
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                    ["w"] = "none",
                    ["<tab>"] = "open",
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
        version = false, -- telescope did only one release, so use HEAD for now
        keys = {
            -- find
            { "<C-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
            {
                "<C-f>",
                function()
                    Util.curr_buf_search()
                end,
                desc = "Fzf Buffer",
            },
            -- TODO:
            -- { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
            -- fd = { "<cmd>Telescope git_files cwd=" .. join_paths(os.getenv "HOME", ".dotfiles") .. "<cr>", "Dotfiles" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find String" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
            -- { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
            -- { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
            -- { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },

            -- fn = { "<cmd>Telescope notify<cr>", "Notifications" }, -- TODO: to make it work
            -- { "<leader>fn", "<cmd>Notifications<cr>", desc = "Notifications" },

            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            -- { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
            -- { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Telescope Commands" },
            -- { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },

            -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },

            -- git
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
            { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "commits" },
            -- search
            -- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
            -- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
            -- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            -- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
            -- { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            -- { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
            -- { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
            -- { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            -- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
            -- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            -- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            -- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
            -- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            -- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
            -- { "<leader>sw", Util.telescope("grep_string"), desc = "Word (root dir)" },
            -- { "<leader>sW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
            -- { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
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
                -- TODO: leave only needed ones
                -- My old stuff
                -- mappings = {
                --     -- almost everything is default
                --     i = {
                --         ["<C-n>"] = actions.move_selection_next,
                --         ["<C-p>"] = actions.move_selection_previous,
                --
                --         ["<C-j>"] = actions.cycle_history_next,
                --         ["<C-k>"] = actions.cycle_history_prev,
                --
                --         ["<C-c>"] = actions.close,
                --
                --         ["<Down>"] = actions.move_selection_next,
                --         ["<Up>"] = actions.move_selection_previous,
                --
                --         ["<CR>"] = actions.select_default,
                --         ["<C-x>"] = actions.select_horizontal,
                --         ["<C-v>"] = actions.select_vertical,
                --         ["<C-t>"] = actions.select_tab,
                --
                --         ["<C-d>"] = actions.delete_buffer,
                --
                --         ["<PageUp>"] = actions.results_scrolling_up,
                --         ["<PageDown>"] = actions.results_scrolling_down,
                --
                --         ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                --         ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                --         ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                --         ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                --         ["<C-l>"] = actions.complete_tag,
                --         ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                --     },
                --
                --     n = {
                --         ["<esc>"] = actions.close,
                --         ["<C-c>"] = actions.close, -- thanks prime now I do it too
                --         ["<CR>"] = actions.select_default,
                --         ["<C-x>"] = actions.select_horizontal,
                --         ["<C-v>"] = actions.select_vertical,
                --         ["<C-t>"] = actions.select_tab,
                --
                --         -- mainly for :Telescope buffers
                --         ["dd"] = actions.delete_buffer,
                --
                --         ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                --         ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                --         ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                --         ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                --
                --         ["j"] = actions.move_selection_next,
                --         ["k"] = actions.move_selection_previous,
                --         ["H"] = actions.move_to_top,
                --         ["M"] = actions.move_to_middle,
                --         ["L"] = actions.move_to_bottom,
                --
                --         ["<Down>"] = actions.move_selection_next,
                --         ["<Up>"] = actions.move_selection_previous,
                --         ["gg"] = actions.move_to_top,
                --         ["G"] = actions.move_to_bottom,
                --
                --         ["<C-u>"] = actions.preview_scrolling_up,
                --         ["<C-d>"] = actions.preview_scrolling_down,
                --
                --         ["<PageUp>"] = actions.results_scrolling_up,
                --         ["<PageDown>"] = actions.results_scrolling_down,
                --
                --         ["?"] = actions.which_key,
                --     },
                -- },
                -- Lazyvim stuff
                -- mappings = {
                --   i = {
                --     ["<c-t>"] = function(...)
                --       return require("trouble.providers.telescope").open_with_trouble(...)
                --     end,
                --     ["<a-t>"] = function(...)
                --       return require("trouble.providers.telescope").open_selected_with_trouble(...)
                --     end,
                --     -- ["<a-i>"] = function()
                --     --   Util.telescope("find_files", { no_ignore = true })()
                --     -- end,
                --     -- ["<a-h>"] = function()
                --     --   Util.telescope("find_files", { hidden = true })()
                --     -- end,
                --     ["<C-Down>"] = function(...)
                --       return require("telescope.actions").cycle_history_next(...)
                --     end,
                --     ["<C-Up>"] = function(...)
                --       return require("telescope.actions").cycle_history_prev(...)
                --     end,
                --     ["<C-f>"] = function(...)
                --       return require("telescope.actions").preview_scrolling_down(...)
                --     end,
                --     ["<C-b>"] = function(...)
                --       return require("telescope.actions").preview_scrolling_up(...)
                --     end,
                --   },
                --   n = {
                --     ["q"] = function(...)
                --       return require("telescope.actions").close(...)
                --     end,
                --   },
                -- },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
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
                    -- theme = "ivy",
                    theme = "dropdown",
                    -- theme = "cursor",
                    previewer = false,
                    show_untracked = true,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    -- initial_mode = "insert" -- or "normal"
                },
            },
        },
    },

    -- TODO: do I want this?
    -- use {
    --     "nvim-telescope/telescope-fzf-native.nvim", -- fzf for telescope
    --     run = "make",
    -- }

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = {
                marks = false, -- shows a list of your marks on ' and `
                registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
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
            key_labels = {
                -- override the label used to display some keys. It doesn't effect WK in any other way.
                -- For example:
                -- ["<space>"] = "SPC",
                ["<leader>"] = "Space",
                -- ["<cr>"] = "RET",
                -- ["<tab>"] = "TAB",
            },
            window = {
                border = "rounded", -- none, single, double, shadow
                -- position = "bottom", -- bottom, top
                -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
                -- padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
                -- winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
            },
            layout = {
                -- height = { min = 4, max = 25 }, -- min and max height of the columns
                -- width = { min = 20, max = 50 }, -- min and max width of the columns
                -- spacing = 3, -- spacing between columns
                align = "center", -- align columns left, center or right
            },
            show_help = false, -- show help message on the command line when the popup is visible
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            local keymaps = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                -- ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                -- ["<leader><tab>"] = { name = "+tabs" },
                -- ["<leader>b"] = { name = "+buffer" },
                ["<leader>f"] = { name = "+find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>m"] = { name = "+make" },
                ["<leader>n"] = { name = "+neogen" },
                ["<leader>p"] = { name = "+plugins" },
                ["<leader>r"] = { name = "+replace/refactor" },
                -- ["<leader>gh"] = { name = "+hunks" },
                -- ["<leader>q"] = { name = "+quit/session" },
                -- ["<leader>s"] = { name = "+search" },
                -- ["<leader>u"] = { name = "+ui" },
                -- ["<leader>w"] = { name = "+windows" },
                -- ["<leader>x"] = { name = "+diagnostics/quickfix" },
            }
            -- if Util.has_plugin("noice.nvim") then
            --   keymaps["<leader>sn"] = { name = "+noice" }
            -- end
            wk.register(keymaps)
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

    -- TODO: will I use this?
    -- easily jump to any location and enhanced f/t motions for Leap
    -- {
    --   "ggandor/flit.nvim",
    --   keys = function()
    --     ---@type LazyKeys[]
    --     local ret = {}
    --     for _, key in ipairs({ "f", "F", "t", "T" }) do
    --       ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
    --     end
    --     return ret
    --   end,
    --   opts = { labeled_modes = "nx" },
    -- },
    -- {
    --   "ggandor/leap.nvim",
    --   keys = {
    --     { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
    --     { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
    --     { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    --   },
    --   config = function(_, opts)
    --     local leap = require("leap")
    --     for k, v in pairs(opts) do
    --       leap.opts[k] = v
    --     end
    --     leap.add_default_mappings(true)
    --     vim.keymap.del({ "x", "o" }, "x")
    --     vim.keymap.del({ "x", "o" }, "X")
    --   end,
    -- },

    -- git client
    {
        "TimUntersberger/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            disable_commit_confirmation = true,
            -- Change the default way of opening neogit
            kind = "replace", -- "replace", "tab", "split", "split_above", "vsplit", "floating"
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
                    ["="] = "Toggle", -- fugitive habbit
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
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
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
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- TODO: will I use these
                -- stylua: ignore
                -- -- Navigation
                -- map("n", "]h", gs.next_hunk, "Next Hunk")
                -- map("n", "[h", gs.prev_hunk, "Prev Hunk")
                -- -- Actions
                -- map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                -- map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                -- map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                -- map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
                -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                -- -- Text object
                -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },

    -- references
    -- {
    --   "RRethy/vim-illuminate",
    --   event = { "BufReadPost", "BufNewFile" },
    --   opts = { delay = 200 },
    --   config = function(_, opts)
    --     require("illuminate").configure(opts)
    --
    --     local function map(key, dir, buffer)
    --       vim.keymap.set("n", key, function()
    --         require("illuminate")["goto_" .. dir .. "_reference"](false)
    --       end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
    --     end
    --
    --     map("]]", "next")
    --     map("[[", "prev")
    --
    --     -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    --     vim.api.nvim_create_autocmd("FileType", {
    --       callback = function()
    --         local buffer = vim.api.nvim_get_current_buf()
    --         map("]]", "next", buffer)
    --         map("[[", "prev", buffer)
    --       end,
    --     })
    --   end,
    --   keys = {
    --     { "]]", desc = "Next Reference" },
    --     { "[[", desc = "Prev Reference" },
    --   },
    -- },

    -- buffer remove (other options: https://github.com/famiu/bufdelete.nvim)
    {
        "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    },
    },

    -- TODO: will I use this?
    -- better diagnostics list and others
    -- {
    --   "folke/trouble.nvim",
    --   cmd = { "TroubleToggle", "Trouble" },
    --   opts = { use_diagnostic_signs = true },
    --   keys = {
    --     { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    --     { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    --     { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    --     { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    --     {
    --       "[q",
    --       function()
    --         if require("trouble").is_open() then
    --           require("trouble").previous({ skip_groups = true, jump = true })
    --         else
    --           vim.cmd.cprev()
    --         end
    --       end,
    --       desc = "Previous trouble/quickfix item",
    --     },
    --     {
    --       "]q",
    --       function()
    --         if require("trouble").is_open() then
    --           require("trouble").next({ skip_groups = true, jump = true })
    --         else
    --           vim.cmd.cnext()
    --         end
    --       end,
    --       desc = "Next trouble/quickfix item",
    --     },
    --   },
    -- },

    -- todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
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
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
    },
}
