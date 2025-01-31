-- fuzzy finder

-- Alternative: "ibhagwan/fzf-lua"
-- Only telescope downside for now: go to definition has no option
-- to go to the first option without prompt; fzf-lua does

return {
    {
        "nvim-telescope/telescope.nvim",
        cond = not CONFIG.plugins.use_fzf_lua,
        cmd = "Telescope",
        branch = "0.1.x",
        -- TODO: add ripgrep as a dependency
        dependencies = {
            "plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim", -- make telescope 20-200 times faster
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
                enabled = vim.fn.executable("gcc") == 1 and vim.fn.executable("make") == 1,
            },
        },
        keys = function()
            local Util = require("core.util")

            return {
                -- find files
                { "<C-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
                {
                    "<leader>ff",
                    Util.telescope("files", { previewer = true }, "default"),
                    desc = "Find Files with preview",
                },

                -- find string
                { "<C-f>", Util.curr_buf_search, desc = "Fzf Buffer" },
                { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "String in Files" },
                { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
                {
                    "<leader>fW",
                    function()
                        require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") })
                    end,
                    desc = "Find WORD under cursor",
                },

                -- find my dotfiles
                {
                    "<leader>fd",
                    Util.telescope(
                        "git_files",
                        -- Yup, why would $HOME on windows be $HOME and not $HOMEPATH or $USERPROFILE
                        {
                            cwd = jit.os:find("Windows") and vim.fs.joinpath(vim.env.HOMEPATH, "dotfiles")
                                or vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
                            prompt_title = "Dotfiles",
                        }
                    ),
                    desc = "Dotfiles",
                },

                -- find my projects
                { "<leader>fp", Util.open_project, desc = "Open [P]roject" },

                -- edit packages
                {
                    "<leader>pe",
                    Util.telescope("find_files", { cwd = vim.fn.stdpath("data") .. "/lazy" }),
                    desc = "Edit Plugins",
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
                { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                {
                    "<leader>fc",
                    Util.telescope("colorscheme", { enable_preview = true }),
                    desc = "Colorscheme w/ preview",
                },

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
            }
        end,
        opts = function()
            local Icons = require("core.icons").ui

            local opts = {
                defaults = {
                    prompt_prefix = Icons.Telescope .. " ", -- default: " ",
                    selection_caret = Icons.Forward .. " ", -- default: " ",
                    -- multi_icons = Icons.Check, -- default: "+",
                    -- path_display = { "shorten" }, -- default: smart (I think)
                    -- border = CONFIG.ui.border ~= "none",
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
            }

            if not jit.os:find("Windows") then
                opts.pickers.find_files.hidden = true
            end

            return opts
        end,
    },
}
