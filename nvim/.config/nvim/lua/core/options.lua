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

-- Settings for Neovide
if vim.g.neovide then
    vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12" -- set the font
    -- vim.opt.guifont = "BlexMono Nerd Font Mono:h12"
    vim.g.neovide_transparency = 0.85 -- make it transparent
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
