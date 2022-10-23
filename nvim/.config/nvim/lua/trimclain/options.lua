local join_paths = require("trimclain.utils").join_paths

local options = {
    fileencoding = "utf-8", -- the encoding written to a file
    completeopt = { "menu", "menuone", "noselect" }, -- required by nvim-cmp
    termguicolors = true, -- set term gui colors (most terminals support this)
    wrap = false, -- display lines as one long line
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    showmatch = true, -- show matching brackets
    textwidth = 0, -- disable breaking the long line of the paste
    wrapmargin = 0, -- simply don't wrap the text (distance from the right border = 0)
    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 4, -- set number column width {default 4}
    hlsearch = true, -- highlight all matches on previous search pattern
    incsearch = true, -- go to search while typing
    ignorecase = true, -- ignore case in search patterns
    smartcase = true, -- except when using capital letters
    hidden = true, -- allows to open multiple buffers
    ruler = true, -- Show the line and column number of the cursor position in the bottom right
    scrolloff = 8, -- start scrolling when 8 lines away from the bottom
    sidescrolloff = 8, --  or  8 chars away from the sides
    wildmenu = true, -- better command-line completion
    showcmd = true, -- show partial commands in the last line of the screen
    colorcolumn = "80", -- vertical column to see 80 characters
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    updatetime = 50, -- faster completion (4000ms default)
    timeoutlen = 500, -- time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    autoindent = true, -- make
    smartindent = true, -- indenting
    smarttab = true, -- smarter
    expandtab = true, -- use spaces instead of tabs
    tabstop = 4, -- insert 4 spaces for \t
    softtabstop = 4, -- insert 4 spaces for <Tab> and <BS> keypresses
    shiftwidth = 4, -- the number of spaces inserted for each indentation level
    backup = false, -- creates a backup file
    swapfile = false, -- creates a swapfile
    undofile = true, -- enable persistent undo
    undodir = join_paths(os.getenv "HOME", ".nvim", "undodir"), -- set the undo directory
    conceallevel = 0, -- so that `` is visible in markdown files
    splitright = true, -- force all vertical splits to go to the right of current window
    mouse = "a", -- enable the mouse
    spell = false, -- enable spellcheck
    spelllang = { "en" }, -- languages used in spellcheck, install new from https://www.mirrorservice.org/pub/vim/runtime/spell/
    -- splitbelow = true, -- force all horizontal splits to go below current window
    -- writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    -- cmdheight = 2, -- more space in the neovim command line for displaying messages
    -- pumheight = 10, -- pop up menu height
    -- showtabline = 2, -- always show tabs
    -- cursorline = true, -- highlight current line
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Settings for Neovide
if vim.g.neovide then
    vim.opt.guifont = "JetBrains Mono:h12" -- set the font
    -- vim.g.neovide_transparency = 0.85 -- make it transparent
    -- vim.g.neovide_cursor_trail_legnth = 0
    -- vim.g.neovide_cursor_animation_length = 0
end

-- TODO: Is there even a point of setting formatoptions here, if they get overwritten anyway?
-- see https://vi.stackexchange.com/questions/9366/set-formatoptions-in-vimrc-is-being-ignored
-- To see what the options are use :h fo-table
vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

-- Sometimes them fingers do be fat
vim.cmd [[com! Q q]]
vim.cmd [[com! Qa qa]]
vim.cmd "com! X x"
vim.cmd "com! W w"
