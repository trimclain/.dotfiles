-- ############################################################################
-- Sets & Lets
-- ############################################################################

-- TODO: do i still need these? If yes, rewrite in lua
-- Enable syntax and plugins
-- syntax enable
-- filetype plugin indent on

local options = {
    fileencoding = "utf-8",                 -- the encoding written to a file
    wrap = false,                           -- display lines as one long line
    showmode = false,                       -- we don't need to see things like -- INSERT -- anymore
    showmatch = true,                       -- show matching brackets
    textwidth = 0,                          -- disable breaking the long line of the paste
    wrapmargin = 0,                         -- simply don't wrap the text (distance from the right border = 0)
    number = true,                          -- set numbered lines
    relativenumber = true,                  -- set relative numbered lines
    numberwidth = 4,                        -- set number column width {default 4}
    hlsearch = true,                        -- highlight all matches on previous search pattern
    incsearch = true,				        -- go to search while typing #GOAT
    ignorecase = true,                      -- ignore case in search patterns
    smartcase = true,                       -- except when using capital letters
    hidden = true,                          -- allows to open multiple buffers
    ruler = true,				            -- Show the line and column number of the cursor position in the bottom right
    scrolloff = 8,                          -- start scrolling when 8 lines away from the bottom
    sidescrolloff = 8,                      --  or  8 chars away from the sides
    wildmenu = true,				        -- better command-line completion
    showcmd = true,				            -- show partial commands in the last line of the screen
    colorcolumn = "80",                     -- vertical column to see 80 characters
    signcolumn = "yes",                     -- always show the sign column, otherwise it would shift the text each time
    updatetime = 50,                        -- faster completion (4000ms default)
    clipboard = "unnamedplus",              -- allows neovim to access the system clipboard
    autoindent = true,                      -- make
    smartindent = true,                     -- indenting
    smarttab = true,                        -- smarter
    expandtab = true,                       -- convert tabs to spaces
    tabstop = 4,                            -- insert 4 spaces
    softtabstop = 4,                        -- for a tab
    shiftwidth = 4,                         -- the number of spaces inserted for each indentation
    backup = false,                         -- creates a backup file
    swapfile = false,                       -- creates a swapfile
    undofile = true,                        -- enable persistent undo
    formatoptions = "tcqjnr",               -- type :h formatoptions to see the meaning of this option and this string
    conceallevel = 0,                       -- so that `` is visible in markdown files
    -- cmdheight = 2,                          -- more space in the neovim command line for displaying messages
    -- pumheight = 10,                         -- pop up menu height
    -- showtabline = 2,                        -- always show tabs
    -- splitbelow = true,                      -- force all horizontal splits to go below current window
    -- splitright = true,                      -- force all vertical splits to go to the right of current window
    -- timeoutlen = 100,                       -- time to wait for a mapped sequence to complete (in milliseconds)
    -- cursorline = true,                      -- highlight the current line
    -- guifont = "monospace:h17",              -- the font used in graphical neovim applications
    -- writebackup = false,                    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

-- " set path+=**                            " expand the search whe gf or :find
-- " Ignore files
-- set wildignore+=*.pyc
-- set wildignore+=*_build/*
-- set wildignore+=**/coverage/*
-- set wildignore+=**/node_modules/*
-- set wildignore+=**/android/*
-- set wildignore+=**/ios/*
-- set wildignore+=**/.git/*


for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.undodir = "~/.nvim/undodir" -- works weird
vim.cmd "set undodir=~/.nvim/undodir"

-- " " Sometimes them fingers do be fat
vim.cmd [[com! Q q]]
vim.cmd "com! X x"
vim.cmd "com! W w"
