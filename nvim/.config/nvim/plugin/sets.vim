" #############################################################################
" Settings
" #############################################################################

set path+=**                            " expand the search whe gf or :find

set nocompatible 			            " disable compatibility to vi
set encoding=utf-8                      " pretty straight-forward
set wildmenu                            " better command-line completion
set showmatch				            " show matching brackets
set nowrap				                " pretty clear
set textwidth=0                         " disable breaking the long line of the paste
set wrapmargin=0                        " simply don't wrap the text (distance from the right border = 0)
set number				                " enable line numbering
set relativenumber			            " show relative line numbers
set nohlsearch				            " don't highlight search results
set incsearch				            " go to search while typing #GOAT
set ignorecase                          " use case insensitive search
set smartcase                           " except when using capital letters
set hidden                              " allows to open multiple buffers
set ruler				                " Show the line and column number of the cursor position in the bottom right
set backspace=indent,eol,start		    " make sure backspace works properly
set scrolloff=8                         " start scrolling when 8 lines away from the bottom
set wildmenu				            " better command-line completion
set showcmd				                " show partial commands in the last line of the screen
set colorcolumn=80                      " vertical column to see 80 characters
set signcolumn=yes                      " enable error-column
" set laststatus=0                        " disable statusbar for airline
set updatetime=50                       " after this many milliseconds of not writing anything the swap file will be written, default 4000 is too long
set formatoptions="tcqjnr"              " type :h formatoptions to see the meaning of this option and this string

" Indentation settings
set autoindent
set expandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set smarttab

" Disable ALL sounds and errorbells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Disable swapfiles
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile
