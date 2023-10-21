-------------------------------------------------------------------------------
--                                                                           --
--   ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗    --
--   ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║    --
--      ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║    --
--      ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║    --
--      ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║    --
--      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    --
--                                                                           --
--       Arthur McLain (trimclain)                                           --
--       mclain.it@gmail.com                                                 --
--       https://github.com/trimclain                                        --
--                                                                           --
-------------------------------------------------------------------------------

-- Important settings for easy modification
CONFIG = {
    opts = {
        -- textwidth = 120,
        tabwidth = 4,
    },
    ui = {
        -- Colorschemes (note/10):
        -- catppuccin (9), tokyonight (9), rose-pine (9), tundra (9)
        -- nightfox (8), vscode (8), gruvbox (8)
        -- github-dark (7), onedark (7), kanagawa (7), zephyr (7)
        -- sonokai (6), omni (6),
        -- darkplus (why does it change colors 5 seconds after launch?)
        colorscheme = "vscode",
        transparent_background = false,
        border = "rounded", -- see ':h nvim_open_win'
        italic_comments = true,
        ghost_text = false,
    },
    git = {
        show_blame = false,
        show_signcolumn = true,
    },
}

-------------------------------------------------------------------------------
-- require("core.options")
-------------------------------------------------------------------------------
local tabwidth = CONFIG.opts.tabwidth

local options = {
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    colorcolumn = "80", -- vertical column to see 80 characters
    completeopt = { "menu", "menuone", "noselect" }, -- required by nvim-cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    expandtab = true, -- use spaces instead of tabs
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    mouse = "a", -- enable the mouse
    number = true, -- print line numbers
    relativenumber = true, -- set relative numbered lines
    ruler = true, -- show the line and column number of the cursor position in the bottom right
    scrolloff = 4, -- start scrolling when 4 lines away from the bottom
    shiftwidth = tabwidth, -- the number of spaces inserted for each indentation level
    showcmd = true, -- show partial commands in the last line of the screen
    showmatch = true, -- show matching brackets
    showmode = false, -- dont show mode since we have a statusline
    sidescrolloff = 8, --  start scrolling when 8 chars away from the sides
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    smartcase = true, -- except when using capital letters
    smartindent = true, -- do smart autoindenting when starting a new line
    softtabstop = tabwidth, -- insert 4 spaces for <Tab> and <BS> keypresses
    spell = false, -- enable or disable spellcheck
    spelllang = { "en" }, -- languages used in spellcheck, install new from https://www.mirrorservice.org/pub/vim/runtime/spell/
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- don't create a swapfile
    tabstop = tabwidth, -- insert 4 spaces for \t
    termguicolors = true, -- set term gui colors (most terminals support this)
    textwidth = 80, -- maximum width of text that is being inserted, used by `gq` command
    timeoutlen = 500, -- time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
    undofile = true, -- enable persistent undo
    undolevels = 10000, -- maximum number of changes that can be undone
    updatetime = 200, -- faster completion (4000ms default)
    winminwidth = 5, -- minimum window width
    wrap = false, -- display lines as one long line
    -- confirm = true -- confirm to save changes before exiting modified buffer
    -- splitbelow = true, -- force all horizontal splits to go below current window
    -- writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    -- cmdheight = 2, -- more space in the neovim command line for displaying messages
    -- pumblend = 10 -- popup blend
    -- pumheight = 10 -- maximum number of entries in a popup
    -- showtabline = 2, -- always show tabs
    -- cursorline = true, -- highlight current line
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
end

-- Settings for Neovide or GUI nvim
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
    -- vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12"
    vim.opt.guifont = "BlexMono Nerd Font Mono:h14"
    -- vim.opt.guifont = "BlexMono Nerd Font Mono:h12"
    vim.api.nvim_create_user_command(
        "FontSize",
        function(cmd)
            local current_font = vim.opt.guifont._value
            -- no gui font set (shouldn't be the case but still checking)
            if current_font == "" then
                return
            end

            local parts = vim.split(vim.trim(cmd.args), "%s+")
            -- more than 1 argument
            if #parts > 1 then
                return
            end

            local font_parts = vim.split(current_font, ":")
            if #parts == 1 and parts[1] ~= "" then
                -- argument not a number
                if not tonumber(parts[1]) then
                    return
                end
                -- set the font size to the given one
                vim.opt.guifont = font_parts[1] .. ":h" .. parts[1]
            else
                -- toggle sizes between 14 and 12
                local new_size = font_parts[2] == "h14" and "h12" or "h14"
                vim.opt.guifont = font_parts[1] .. ":" .. new_size
            end
        end,
        { nargs = "?", desc = "Update gui font size" }
    )
end
if vim.g.neovide then
    vim.g.neovide_transparency = 0.95
    -- vim.g.neovide_cursor_trail_legnth = 0
    -- vim.g.neovide_cursor_animation_length = 0
end

-- "o" gets overwritten on startup, so I have an autocommand to fix it
-- see https://vi.stackexchange.com/questions/9366/set-formatoptions-in-vimrc-is-being-ignored
-- To see what the options are use :h fo-table
vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

-- Sometimes them fingers do be fat
vim.cmd([[com! Q q]])
vim.cmd([[com! Qa qa]])
vim.cmd("com! X x")
vim.cmd("com! W w")

-------------------------------------------------------------------------------
-- require("core.util")
-------------------------------------------------------------------------------
--- Fuzzy find in current buffer
local curr_buf_search = function()
    local opt = require("telescope.themes").get_dropdown({ height = 10, previewer = false })
    require("telescope.builtin").current_buffer_fuzzy_find(opt)
end

--- Send INFO notifications
---@param msg string
---@param title string
local function notify(msg, title)
    print(title .. ": " .. msg)
    -- vim.notify(msg, vim.log.levels.INFO, { title = title })
end

--- Open a URL with the current operating system
---@param path string The path of the file to open with the system opener
local function system_open(path)
    local cmd
    if vim.fn.has("win32") == 1 and vim.fn.executable("explorer") == 1 then
        cmd = { "cmd.exe", "/K", "explorer" }
    elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
        cmd = { "xdg-open" }
    elseif (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1) and vim.fn.executable("open") == 1 then
        cmd = { "open" }
    end
    if not cmd then
        vim.notify("Available system opening tool not found!", vim.log.levels.ERROR)
    end
    vim.fn.jobstart(vim.fn.extend(cmd, { path }), { detach = true })
end

--- Find URL in current line and open it with the current operating system
local function open_url()
    --- regex used for matching a valid URL/URI string
    local url_matcher =
        "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"
    local url = vim.fn.matchstr(vim.fn.getline("."), url_matcher)
    if url ~= "" then
        notify("Opened " .. url, "URL Handler")
        system_open(url)
    else
        notify("No URL found", "URL Handler")
    end
end

-------------------------------------------------------------------------------
-- require("core.keymaps")
-------------------------------------------------------------------------------
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

--- Extend opts by adding a description, so the keymap appears in which-key
---@param desc string
---@return table
local add_desc = function(desc)
    return vim.tbl_extend("error", opts, { desc = desc })
end

-- Make space a leader key. This needs to happen before lazy.nvim setup.
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Esc is too far and I don't like <C-[>, make <C-c> work as <Esc> in every mode
keymap("", "<C-c>", "<Esc>", opts) -- normal, visual, select, operator-pending modes
keymap("l", "<C-c>", "<Esc>", opts) -- insert, command-line, lang-arg modes
keymap("i", "<C-c>", "<Esc>", opts) -- insert mode again, coz doesn't work above

-- INFO:
-- How to modify macros:
-- paste from register: "ap
-- edit
-- yank back to the register: "ayy

-- INFO:
-- How to change split directions:
-- vertical to horizontal: <c-w>K
-- horizontal to vertical: <c-w>H

-- INFO:
-- How to check where was the keymap defined:
-- map <keymap> for Normal, Visual, Select, Operator-pending modes
-- map! <keymap> for Insert and Command-line modes

--
-- Easier movement between buffers (I'm fine with arrows and <C-w>jk for now -> more keys for whichkey)
-- keymap("n", "<left>", "<C-w>h", opts)
-- keymap("n", "<right>", "<C-w>l", opts)
-- keymap("n", "<leader>j", "<C-w>j", opts)
-- keymap("n", "<leader>k", "<C-w>k", opts)

--
-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

--
-- Resizing: Use Ctrl + arrows to resize buffers
keymap("n", "<C-Up>", ":resize -5<cr>", opts)
keymap("n", "<C-Down>", ":resize +5<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<cr>", opts)

--
-- Very Useful Stuff
keymap("n", "<leader><cr>", "<cmd>source %<cr>", add_desc("Source Buffer"))
keymap("n", "gp", "`[v`]", add_desc("Select recently pasted text"))
keymap("n", "Q", "<cmd>qa<cr>", opts) -- remap Q to :qa
keymap("n", "n", "nzzzv", opts) -- keep it centered when searching forward
keymap("n", "N", "Nzzzv", opts) -- and backwards

keymap("n", "<C-u>", "<C-u>zz", opts) -- keep it centered when scrolling up
keymap("n", "<C-d>", "<C-d>zz", opts) -- and down

keymap("n", "J", "mzJ`z", opts) -- keep it centered when joining lines
keymap("i", ",", ",<c-g>u", opts) -- set a break point for undo after ,
keymap("i", ".", ".<c-g>u", opts) -- after .
keymap("i", "!", "!<c-g>u", opts) -- after !
keymap("i", "?", "?<c-g>u", opts) -- after ?
keymap("v", "K", ":m '<-2<cr>gv=gv", opts) -- move higlighted lines up a line
keymap("v", "J", ":m '>+1<cr>gv=gv", opts) -- and down a line
keymap("v", "<", "<gv", opts) -- stay in indent mode
keymap("v", ">", ">gv", opts) -- stay in indent mode
keymap("v", "<S-h>", "<gv", opts) -- feels natural
keymap("v", "<S-l>", ">gv", opts) -- feels natural
keymap("v", "y", "myy`y", opts) -- Maintain the cursor position
keymap("v", "Y", "myy`y", opts) -- when yanking a visual selection
keymap("v", "p", '"_dP', opts) -- when replacing a higlighted text, don't yank it
keymap("n", "<leader>d", '"_d', add_desc("Delete to black hole"))
keymap("i", "<C-r>", "<C-r>+", opts) -- paste from clipboard in insert mode
keymap("c", "<C-r>", "<C-r>+", opts) -- paste from clipboard in command mode
keymap("n", "<leader>r.", ":%s/\\<<c-r><c-w>\\>/", add_desc("Replace Word Vim Style"))
keymap("n", "<leader>Y", 'gg"+yG', add_desc("Yank Whole File"))
keymap("n", "<leader>w", "<cmd>w<cr>", add_desc("Save File"))

-- Store relative line number jumps in the jumplist if they exceed a threshold.
keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- convert fileformat from dos/unix to unix (https://vim.fandom.com/wiki/File_format#Converting_the_current_file)
keymap(
    "n",
    "<leader>vu",
    ":update<cr> :e ++ff=dos<cr> :setlocal ff=unix<cr> :w<cr>",
    add_desc("Change fileformat from dos to unix")
)

-- stylua: ignore
keymap("n", "gx", function() open_url() end, add_desc("Open URL under cursor"))
-- keymap("n", "gX", function() require("core.util").open_github_url() end, add_desc("Open Github URL under cursor"))
-- keymap("n", "<leader>re", function() require("core.util").empty_registers() end, add_desc("Empty registers"))

-------------------------------------------------------------------------------

-- Lazy
keymap("n", "<leader>pl", "<cmd>Lazy home<cr>", add_desc("Open Lazy"))
keymap("n", "<leader>ps", "<cmd>Lazy sync<cr>", add_desc("Lazy Sync"))
keymap("n", "<leader>pp", "<cmd>Lazy profile<cr>", add_desc("Lazy Profile"))
keymap("n", "<leader>pr", "<cmd>Lazy restore<cr>", add_desc("Lazy Restore using lazy-lock.json"))

-- " QuickFixList Stuff
-- keymap("n", "<up>", ":cprev<CR>zz", opts)
-- keymap("n", "<down>", ":cnext<CR>zz", opts)
-- keymap("n", "<C-q>", "<cmd>lua require('core.utils').ToggleQFList()<CR>", opts)

-------------------------------------------------------------------------------
-- require("core.lazy")
-------------------------------------------------------------------------------
-- Install lazy.nvim if needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    -- colorscheme
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "vscode",
        opts = {
            transparent = CONFIG.ui.transparent_background,
            italic_comments = CONFIG.ui.italic_comments,
        },
        config = function(_, opts)
            require("vscode").setup(opts)
            vim.cmd.colorscheme("vscode")
        end,
    },
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            -- stylua: ignore
            { "<C-f>", function() curr_buf_search() end, desc = "Fzf Buffer" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
            { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },

            -- git
            -- { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
            -- { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "commits" },
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
                        -- keys from pressing <C-/>
                        ["<C-_>"] = function(...)
                            require("telescope.actions").which_key(...)
                        end,
                    },

                    n = {
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
        },
    },
    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "VeryLazy", -- '/' and ':' autocomplete won't always work on InsertEnter
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
        },
        config = function()
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                -- Make it round
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    -- To scroll through a big popup window
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    -- Show autocomplete options without typing anything
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ["<S-CR>"] = cmp.mapping.confirm({
                    --   behavior = cmp.ConfirmBehavior.Replace,
                    --   select = true,
                    -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    --
                    -- Make SuperTab
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        -- I have my own keybinds for this in luasnip config
                        -- elseif luasnip.expand_or_jumpable() then
                        --     luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        -- elseif luasnip.jumpable(-1) then
                        --     luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    -- { name = "nvim_lsp_signature_help" },
                    -- { name = "nvim_lsp" },
                    {
                        name = "latex_symbols",
                        option = {
                            -- @usage 0 (mixed) | 1 (julia) | 2 (latex)
                            strategy = 0,
                        },
                    },
                    { name = "luasnip" },
                    { name = "path" },
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                        },
                    },
                    { name = "buffer", keyword_length = 1 }, -- keyword_length specifies word length to start suggestions
                }),
                formatting = {
                    fields = { "abbr", "menu" },
                    format = function(entry, item)
                        item.menu = ({
                            -- nvim_lsp = "[LSP]",
                            -- nvim_lsp_signature_help = "[sign]",
                            latex_symbols = "[symb]",
                            luasnip = "[snip]",
                            path = "[path]",
                            spell = "[spell]",
                            buffer = "[buf]",
                            cmdline = "[cmd]",
                        })[entry.source.name]
                        return item
                    end,
                },
                experimental = {
                    -- @usage boolean | { hl_group = string }
                    ghost_text = CONFIG.ui.ghost_text, -- show completion preview inline
                },
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline", keyword_length = 2 }, -- otherwise too much info
                }),
            })
        end,
    },
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            update_events = { "TextChanged", "TextChangedI" },
            delete_check_events = "TextChanged",
        },
        config = function(_, opts)
            local luasnip = require("luasnip")
            luasnip.setup(opts)
            luasnip.filetype_extend("javascript", { "javascriptreact", "html" }) -- add jsx and html snippets to js
            luasnip.filetype_extend("javascriptreact", { "javascript", "html" }) -- add js and html snippets to jsx
            luasnip.filetype_extend("typescriptreact", { "javascript", "html" }) -- add js and html snippets to tsx
        end,
        keys = {
            {

                "<c-k>",
                function()
                    local luasnip = require("luasnip")
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end,
                silent = true,
                mode = { "i", "s" },
            },
            {
                "<c-j>",
                function()
                    local luasnip = require("luasnip")
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end,
                silent = true,
                mode = { "i", "s" },
            },
            {
                "<c-h>",
                function()
                    local luasnip = require("luasnip")
                    if luasnip.choice_active() then
                        luasnip.change_choice(-1)
                    end
                end,
                mode = { "i", "s" },
            },
            {
                "<c-l>",
                function()
                    local luasnip = require("luasnip")
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    end
                end,
                mode = { "i", "s" },
            },
        },
    },
    -- TODO: neotree?

    -- undotree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
        },
    },
    -- comments
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup({
                ignore = "^$", -- ignores empty lines
            })

            local comment_ft = require("Comment.ft")
            comment_ft.set("rasi", { "//%s", "/*%s*/" }) -- rofi config
            -- comment_ft.set("lua", { "--%s", "--[[%s]]" })
            -- comment_ft.set("markdown", { "[//]:%s", "<!--%s-->" })
        end,
    },
    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
}, {
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = false, -- always use the latest git commit
    },
    -- try to load one of these colorschemes when starting an installation during startup
    install = { colorscheme = { CONFIG.ui.colorscheme, "habamax" } },
    ui = { border = CONFIG.ui.border },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false, -- maybe later
        notify = true, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile_plugin",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})

-------------------------------------------------------------------------------
-- require("core.autocmd")
-------------------------------------------------------------------------------
local function augroup(name)
    return vim.api.nvim_create_augroup("trimclain" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    command = "checktime",
    desc = "Check if we need to reload the file when it changed",
    group = augroup("checktime"),
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            -- higroup = "IncSearch",
            -- higroup = "Substitute",
            higroup = "Search",
            timeout = 100,
            on_macro = true,
            on_visual = true,
        })
    end,
    desc = "Highlight text on yank",
    group = augroup("highlight_on_yank"),
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Resize splits if window got resized",
    group = augroup("resize_splits"),
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        unpack = unpack or table.unpack
        local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
        if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { row, col })
        end
    end,
    desc = "Return to last known cursor position",
    group = augroup("restore_cursor_position"),
})

-- Trim whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
    command = "%s/\\s\\+$//e",
    desc = "Delete useless whitespaces when saving the file",
    group = augroup("trim_whitespace_on_save"),
})

-- Fix formatoptions since they get overwritten (see options.lua:65)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
    desc = "Fix formatoptions",
    group = augroup("fix_formatoptions"),
})

-- Close these filetypes with a single keypress instead of :q
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf", -- QuickFixList
        "help", -- nvim help
        "man", -- nvim man pages
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Set these filetypes to close with q-press and to not be in the buffers list",
    group = augroup("close_with_q"),
})
