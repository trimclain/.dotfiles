"#############################################################################"
"        ______ ___    __ __   ___    ____  __     __     __  __   __         "
"       /_  __//   \  / //  \ /   |  / __/ / /    /  |   / / /  \ / /         "
"        / /  /   _/ / // /\\/ /| | / /   / /    /   |  / / / /\\/ /          "
"       / /  / /\ \ / // / \/_/ | |/ /__ / /___ / _  | / / / / \/ /           "
"      /_/  /_/ \_\/_//_/       |_|\___//_____//_/ \_|/_/ /_/  /_/            "
"                                                                             "
"                                                                             "
"       Arthur McLain (trimclain)                                             "
"       mclain.it@gmail.com                                                   "
"       https://github.com/trimclain                                          "
"                                                                             "
"#############################################################################"

" Don't try to be vi compatible
set nocompatible

" Don't wrap lines
set nowrap
set textwidth=0
set wrapmargin=0

" Encoding
set encoding=utf-8

" Show line number
set number
set relativenumber

" Make search not hilighted
set nohlsearch

" Change buffers even if a file is unsaved
set hidden

" Show row and column ruler informantion
set ruler

" Backspace
set backspace=indent,eol,start

" Tab and indent
set autoindent
set expandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set smarttab

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" enable syntax and plugins
syntax enable
filetype plugin indent on

" NetRW sets
let g:netrw_browse_split=0              " open in same window
let g:netrw_banner=0                    " disable annoying banner
let g:netrw_altv=1                      " open splits to the right
let g:netrw_winsize=75                  " when pressing v/t have the new split be 75% of the whole screen
let g:newrw_localrmdir='rm -r'

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" No swapfiles
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set incsearch

" Start scrolling when I'm 8 lines away from edges
set scrolloff=8

" Set 80 charakter column and set left colimn for errors
set colorcolumn=80
set signcolumn=yes

" No statusbar because airline
set laststatus=0

" #############################################################################
" PLUGINS"
" #############################################################################

" Install Plugins
call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'
Plug 'jremmen/vim-ripgrep'
Plug 'kien/ctrlp.vim'
call plug#end()

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
\| endif

" Enable and Modify Plugins

" Colorscheme
let g:gruvbox_contrast_dark = 'hard'

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8e = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

colorscheme gruvbox
set background=dark

" Make the background transparent
highlight Normal ctermbg=NONE guibg=NONE

" Some Configurations from old Prime
if executable('rg')
    let g:rg_derive_root='true'
endif

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files --exclude-standard']
let g:ctrlp_user_command = 0

" SET LEADER KEY
let mapleader = " "

" #############################################################################
" REMAPS
" #############################################################################

" Easier movement between vim windows
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Open Undotree
nnoremap <leader>u :UndotreeShow<CR>

" View the Project Tree in netrw
nnoremap <silent> <leader>pv :Ex<CR>
" Start a Project Search
nnoremap <leader>ps :Rg<SPACE>

" Make moving higlighted lines up and down a line easier
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Make Y work like C and D
nnoremap Y y$

" Keeping it centered when going to next on search and when joining lines
nnoremap n nzzzv
nnoremap N Nzzzv
" ' works instead of ` aswell
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Disable arrow keys to learn vim movement
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" #############################################################################
" Autocommands
" #############################################################################

" Delete useless spaces
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" highlight when yanking
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup trimclain
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
