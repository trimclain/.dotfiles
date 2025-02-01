-- fzf in neovim
return {
    {
        "ibhagwan/fzf-lua",
        enabled = vim.fn.executable("fzf") == 1,
        cond = CONFIG.plugins.use_fzf_lua,
        cmd = "FzfLua",
        dependencies = { "nvim-web-devicons" },
        keys = function()
            -- local Util = require("core.util")

            -- TODO: https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#commands
            return {

                -- find files
                -- TODO: rewrite util
                -- { "<C-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
                -- {
                --     "<leader>ff",
                --     Util.telescope("files", { previewer = true }, "default"),
                --     desc = "Find Files with preview",
                -- },
                { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },

                -- find string
                -- TODO: rewrite util
                -- { "<C-f>", Util.curr_buf_search, desc = "Fzf Buffer" },
                {
                    "<C-f>",
                    function()
                        require("fzf-lua").lgrep_curbuf({
                            winopts = {
                                height = 0.6,
                                width = 0.5,
                                preview = { vertical = "up:70%" },
                            },
                        })
                    end,
                    desc = "Grep current buffer",
                },
                { "<leader>fg", "<cmd>FzfLua live_grep_glob<cr>", desc = "Grep" },
                { "<leader>fg", "<cmd>FzfLua grep_visual<cr>", desc = "Grep", mode = "x" },
                -- { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "String in Files" },
                -- { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
                -- {
                --     "<leader>fW",
                --     function()
                --         require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") })
                --     end,
                --     desc = "Find WORD under cursor",
                -- },

                -- -- find my dotfiles
                -- {
                --     "<leader>fd",
                --     Util.telescope(
                --         "git_files",
                --         -- Yup, why would $HOME on windows be $HOME and not $HOMEPATH or $USERPROFILE
                --         {
                --             cwd = jit.os:find("Windows") and vim.fs.joinpath(vim.env.HOMEPATH, "dotfiles")
                --                 or vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
                --             prompt_title = "Dotfiles",
                --         }
                --     ),
                --     desc = "Dotfiles",
                -- },

                -- -- find my projects
                -- { "<leader>fp", Util.open_project, desc = "Open [P]roject" },

                -- -- edit packages
                -- {
                --     "<leader>pe",
                --     Util.telescope("find_files", { cwd = vim.fn.stdpath("data") .. "/lazy" }),
                --     desc = "Edit Plugins",
                -- },

                { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
                -- { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
                -- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
                -- new:
                { "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Document diagnostics" },
                { "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
                -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
                -- { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
                -- { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
                { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "Highlight Groups" },
                { "<leader>fl", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },
                -- { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
                -- { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
                -- { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                -- {
                --     "<leader>fc",
                --     Util.telescope("colorscheme", { enable_preview = true }),
                --     desc = "Colorscheme w/ preview",
                -- },

                -- -- git
                -- { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
                -- { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "commits" },

                -- ?
                -- {
                --     "<leader>fr",
                --     function()
                --         -- Read from ShaDa to include files that were already deleted from the buffer list.
                --         vim.cmd("rshada!")
                --         require("fzf-lua").oldfiles()
                --     end,
                --     desc = "Recently opened files",
                -- },

                -- TODO: could be interesting (currently which-key has it bound)
                { "z=", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling suggestions" },
            }
        end,
        opts = function()
            -- local actions = require 'fzf-lua.actions'

            -- TODO: https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#customization
            -- and https://www.lazyvim.org/extras/editor/fzf#fzf-lua
            return {
                "default-title",
                -- Make stuff better combine with the editor.
                fzf_colors = {
                    bg = { "bg", "Normal" },
                    gutter = { "bg", "Normal" },
                    info = { "fg", "Conditional" },
                    scrollbar = { "bg", "Normal" },
                    separator = { "fg", "Comment" },
                },
                -- fzf_opts = {
                --     ['--info'] = 'default',
                --     -- ['--layout'] = 'reverse-list',
                -- },
                winopts = {
                    height = 0.7,
                    width = 0.55,
                    border = CONFIG.ui.border,
                    preview = {
                        border = CONFIG.ui.border,
                        scrollbar = false,
                        layout = "vertical",
                        vertical = "up:40%",
                    },
                },
                keymap = {
                    -- builtin = {
                    --     ["<C-/>"] = "toggle-help",
                    --     ["<C-a>"] = "toggle-fullscreen",
                    --     ["<C-i>"] = "toggle-preview",
                    --     -- ["<C-f>"] = "preview-page-down",
                    --     -- ["<C-b>"] = "preview-page-up",
                    -- },
                    -- fzf = {
                    --     ["alt-s"] = "toggle",
                    --     ["alt-a"] = "toggle-all",
                    -- },
                },
                -- defaults = { git_icons = false },
                -- -- Configuration for specific commands.
                -- files = {
                --     winopts = {
                --         preview = { hidden = 'hidden' },
                --     },
                -- },
                -- grep = {
                --     header_prefix = icons.misc.search .. ' ',
                -- },
                -- helptags = {
                --     actions = {
                --         -- Open help pages in a vertical split.
                --         ['enter'] = actions.help_vert,
                --     },
                -- },
                -- lsp = {
                --     symbols = {
                --         symbol_icons = icons.symbol_kinds,
                --     },
                -- },
                -- oldfiles = {
                --     include_current_session = true,
                --     winopts = {
                --         preview = { hidden = 'hidden' },
                --     },
                -- },
            }
        end,
    },
}
