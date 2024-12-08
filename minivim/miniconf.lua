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
        colorscheme = "astrospeed", -- astrospeed, primer-dark, vscode
        transparent_background = false,
        border = "rounded", -- see ':h nvim_open_win'
        italic_comments = true,
        cursorline = true,
        ghost_text = false,
    },
    git = {
        show_blame = false,
        show_signcolumn = true,
    },
}

-------------------------------------------------------------------------------
-- OPTIONS
-- require("core.options")
-------------------------------------------------------------------------------
local options = {
    clipboard = "unnamedplus", -- allow neovim to access the system clipboard
    colorcolumn = "80", -- vertical column to see 80 characters
    completeopt = { "menu", "menuone", "noselect" }, -- list of options for insert mode completion (for nvim-cmp)
    conceallevel = 0, -- so that `` is visible in markdown files
    cursorline = CONFIG.ui.cursorline, -- highlight current line
    expandtab = true, -- use spaces instead of tabs
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    inccommand = "split", -- show effects of :substitute in a preview window
    mouse = "a", -- enable the mouse
    number = true, -- print line numbers
    relativenumber = true, -- set relative numbered lines
    ruler = true, -- show the line and column number of the cursor position in the bottom right
    scrolloff = 4, -- start scrolling when 4 lines away from the bottom
    shiftwidth = CONFIG.opts.tabwidth, -- the number of spaces inserted for each indentation level
    showcmd = true, -- show partial commands in the last line of the screen
    showmatch = true, -- show matching brackets
    showmode = false, -- dont show mode since we have a statusline
    sidescrolloff = 8, --  start scrolling when 8 chars away from the sides
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    smartcase = true, -- except when using capital letters
    smartindent = true, -- do smart autoindenting when starting a new line
    softtabstop = CONFIG.opts.tabwidth, -- insert 4 spaces for <Tab> and <BS> keypresses (don't set with tpope/vim-sleuth)
    spell = false, -- enable or disable spellcheck
    spelllang = { "en" }, -- languages used in spellcheck, install new from https://www.mirrorservice.org/pub/vim/runtime/spell/
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- don't create a swapfile
    tabstop = CONFIG.opts.tabwidth, -- insert 4 spaces for a <Tab>
    termguicolors = true, -- set term gui colors (most terminals support this)
    textwidth = 80, -- maximum width of text that is being inserted, used by `gq` command
    timeoutlen = 500, -- time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
    undofile = true, -- enable undo history
    undolevels = 10000, -- maximum number of changes that can be undone
    updatetime = 200, -- faster completion (4000ms default)
    virtualedit = "block", -- allows cursor to move where there is no text in visual block mode
    winminwidth = 5, -- minimum window width
    wrap = false, -- display lines as one long line
    splitkeep = "screen", -- keep the text on the same screen line when working with splits
    -- confirm = true -- confirm to save changes before exiting modified buffer
    -- splitbelow = true, -- force all horizontal splits to go below current window
    -- writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    -- cmdheight = 2, -- more space in the neovim command line for displaying messages
    -- pumblend = 10 -- popup blend
    -- pumheight = 10 -- maximum number of entries in a popup
    -- showtabline = 2, -- always show tabs
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-----------------------------------------------------------------------------------------------------------------------
-- Settings for Neovide or GUI nvim
-----------------------------------------------------------------------------------------------------------------------
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
    -- vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12"
    -- vim.opt.guifont = "BlexMono Nerd Font Mono:h14"
    vim.opt.guifont = "CaskaydiaCove Nerd Font Mono:h14"
    -- vim.opt.guifont = "BlexMono Nerd Font Mono:h12"
    vim.api.nvim_create_user_command("FontSize", function(cmd)
        local current_font = vim.o.guifont
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
    end, { nargs = "?", desc = "Update gui font size" })
end
if vim.g.neovide then
    vim.g.neovide_transparency = 1 -- 0.95
    -- vim.g.neovide_cursor_trail_legnth = 0
    -- vim.g.neovide_cursor_animation_length = 0
end
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
-- UI characters
-----------------------------------------------------------------------------------------------------------------------
-- List mode (`:h 'list'`)
vim.opt.list = true
vim.opt.listchars = {
    eol = "↲", -- "↴", "⤶", ""
    nbsp = "␣", -- ""
    tab = "󰌒 ", -- "▸ ", "󰌒 ", "<->"
    trail = " ",
    -- lead = "⋅", -- "␣", "", "_"
}

-- fillchars (`:h 'fillchars'`)
vim.opt.fillchars = {
    eob = " ", -- empty lines at the end of a buffer
    -- fold = " ", -- filling 'foldtext'
    foldopen = "", -- mark the beginning of a fold
    foldclose = "", -- show a closed fold
    foldsep = " ", -- open fold middle marker
    -- msgsep = "─", -- message separator 'display'
}
-----------------------------------------------------------------------------------------------------------------------

-- Folding.
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 0 -- 0 (all folds closed), 1 (some folds closed), 99 (no folds closed)
-- vim.o.foldmethod = "expr" -- "manual", "indent", "expr", "marker", "syntax", "diff",
-- vim.wo.foldtext = 'v:lua.vim.treesitter.foldtext()'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Diff mode settings.
-- Setting the context to a very large number disables folding.
-- vim.opt.diffopt:append 'vertical,context:99'

-- Disable search count wrap and startup messages
vim.opt.shortmess:append({ s = true, I = true }) -- c = true

-- Disable health checks for these providers.
-- vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

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
-- UTILITIES
-- require("core.util")
-------------------------------------------------------------------------------
--- Fuzzy find in current buffer
local curr_buf_search = function()
    -- FIX: broken with any theme
    -- local opt = require("telescope.themes").get_dropdown({ height = 10, previewer = false })
    require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
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
-- KEYMAPS
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
keymap("n", "<leader><cr>", "<cmd>e $MYVIMRC<cr>", add_desc("Edit Config"))
-- keymap("n", "<leader><cr>", "<cmd>source %<cr>", add_desc("Source Buffer"))
keymap("n", "gp", "`[v`]", add_desc("Select recently pasted text"))
keymap("n", "Q", "<cmd>qa<cr>", opts) -- remap Q to :qa
keymap("n", "n", "nzzzv", opts) -- keep it centered when searching forward
keymap("n", "N", "Nzzzv", opts) -- and backwards

-- keymap("n", "<C-u>", "<C-u>zz", opts) -- keep it centered when scrolling up
-- keymap("n", "<C-d>", "<C-d>zz", opts) -- and down

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
-- keymap("n", "<leader>d", '"_d', add_desc("Delete to black hole"))
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
-- PLUGINS
-- require("core.lazy")
-------------------------------------------------------------------------------
-- Install lazy.nvim if needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
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
    {
        "LunarVim/primer.nvim",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "primer-dark",
        config = function()
            vim.cmd.colorscheme("primer_dark")
        end,
    },
    {
        "trimclain/astrospeed",
        lazy = false,
        priority = 1000,
        cond = CONFIG.ui.colorscheme == "astrospeed",
        config = function()
            vim.cmd.colorscheme("astrospeed")
        end,
    },
    -- file explorer
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
                                system_open(node.path)
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
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
    },
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<C-f>", curr_buf_search, desc = "Fzf Buffer" },
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
                    hidden = true,
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
    -- treesitter
    {
        -- REQUIREMENT: `scoop install gcc`
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        enabled = vim.fn.executable("gcc") == 1,
        event = { "BufReadPost", "BufNewFile" },
        -- dependencies = {
        --     {
        --         "nvim-treesitter/nvim-treesitter-context",
        --         keys = {
        --             {
        --                 "[c",
        --                 function()
        --                     require("treesitter-context").go_to_context()
        --                 end,
        --                 desc = "Jump to context (upwards)",
        --             },
        --         },
        --         config = function()
        --             require("treesitter-context").setup({
        --                 max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
        --             })
        --         end,
        --     },
        -- },
        -- keys = {
        --   { "<c-space>", desc = "Increment selection" },
        --   { "<bs>", desc = "Decrement selection", mode = "x" },
        -- },
        opts = {
            highlight = {
                enable = true,
                -- disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    -- return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            indent = {
                enable = true,
                disable = { "julia" }, -- sadly broken right now
            },
            context_commentstring = { enable = true, enable_autocmd = false }, -- nvim-ts-context-commentstring
            autotag = { enable = true }, -- nvim-ts-autotag
            -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ensure_installed = {
                "html",
                "javascript",
                "python",

                "json",
                "jsonc",
                "xml",

                "markdown",
                "markdown_inline",
                "regex",

                -- should always be installed
                "c",
                "vim",
                "vimdoc",
                "lua",
                "query", -- treesitter query
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
        },
        config = function(_, opts)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require("nvim-treesitter.install").prefer_git = true

            require("nvim-treesitter.configs").setup(opts)
        end,
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
                    ["<C-y>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        }),
                        { "i", "c" }
                    ),
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
                    -- {
                    --     name = "latex_symbols",
                    --     option = {
                    --         -- @usage 0 (mixed) | 1 (julia) | 2 (latex)
                    --         strategy = 0,
                    --     },
                    -- },
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
                -- use defaults for sorting stragegy
                sorting = require("cmp.config.default")().sorting,
                formatting = {
                    -- fields = { "kind", "abbr", "menu" },
                    fields = { "abbr", "menu" },
                    format = function(entry, item)
                        item.menu = ({
                            -- nvim_lsp = "[LSP]",
                            -- nvim_lsp_signature_help = "[sign]",
                            -- latex_symbols = "[symb]",
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
    -- git client
    {
        "NeogitOrg/neogit",
        -- https://github.com/NeogitOrg/neogit/tree/68a3e90e9d1ed9e362317817851d0f34b19e426b?tab=readme-ov-file#configuration
        commit = "68a3e90", -- pin until it's fixed
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                disable_commit_confirmation = true, -- config relevant for pinned commit
                disable_insert_on_commit = true, -- "auto", "true" or "false"
                kind = "tab", -- "tab", "split", "split_above", "vsplit", "floating"
                commit_popup = { -- config relevant for pinned commit
                    kind = "split", -- default: "auto"
                },
                mappings = {
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
    -- close buffers
    {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
        },
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
    -- advanced note taking, project/task management
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        ft = "norg",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
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
                },
            })

            vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", { desc = "Toggle Neorg Concealer" })
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
        notify = false, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip", -- read *.Z, *.gz, *.bz2, *.lzma, *.xz, *.lz and *.zst files in vim
                -- "matchit", -- better % matches
                "matchparen", -- highlight matching parentheses
                "netrwPlugin", -- builtin file explorer
                "rplugin", -- remote plugin support
                "tarPlugin", -- read *.tar files in vim
                "tohtml", -- convert current window to html
                "tutor", -- vim tutor
                "zipPlugin", -- read *.zip files in vim
            },
        },
    },
})

-------------------------------------------------------------------------------
-- AUTOCOMMANDS
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
            -- higroup = "Search",
            higroup = "Visual",
            timeout = 75,
            on_macro = true,
            on_visual = true,
            priority = 250,
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
            vim.cmd.normal("zz")
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
        "startuptime", -- dstein64/vim-startuptime
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Set these filetypes to close with q-press and to not be in the buffers list",
    group = augroup("close_with_q"),
})

-- Hide cursorline in insert mode
if CONFIG.ui.cursorline then
    local cursorline_toggle = augroup("cursorline_toggle")
    vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
        pattern = "*",
        command = "set cursorline",
        desc = "Enable cursorline in normal mode",
        group = cursorline_toggle,
    })
    vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
        pattern = "*",
        command = "set nocursorline",
        desc = "Disable cursorline in insert mode",
        group = cursorline_toggle,
    })
end

-- set conceallevel for markdown files
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.md", "*.norg" },
    callback = function()
        vim.opt_local.conceallevel = 2
    end,
    desc = "Set Conceallevel for markdown",
    group = augroup("set_conceallevel_markdown"),
})

if vim.fn.has("win32") == 1 then
    -- Restore cursor shape (needed only on Windows Terminal)
    vim.api.nvim_create_autocmd("VimLeave", {
        command = 'set guicursor= | call chansend(v:stderr, "\x1b[ q")',
        desc = "Restore windows terminal cursor shape",
        group = augroup("restore_cursor_shape"),
    })
end
