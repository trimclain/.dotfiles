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

" Enable syntax and plugins
syntax enable
filetype plugin indent on

" #############################################################################
" Settings
" #############################################################################

set path+=**                            " expand the search whe gf or :find

set nocompatible                        " disable compatibility to vi
set encoding=utf-8                      " pretty straight-forward

set wildmenu                            " better command-line completion
set showmatch                           " show matching brackets
set nowrap                              " pretty clear
set textwidth=0                         " disable breaking the long line of the paste
set wrapmargin=0                        " simply don't wrap the text (distance from the right border = 0)
set number                              " enable line numbering
set relativenumber                      " show relative line numbers
set nohlsearch                          " don't highlight search results
set incsearch                           " go to search while typing #GOAT
set ignorecase                          " use case insensitive search
set smartcase                           " except when using capital letters
set hidden                              " allows to open multiple buffers
set ruler                               " Show the line and column number of the cursor position in the bottom right
set backspace=indent,eol,start          " make sure backspace works properly
set scrolloff=8                         " start scrolling when 8 lines away from the bottom
set wildmenu                            " better command-line completion
set showcmd                             " show partial commands in the last line of the screen
set colorcolumn=80                      " vertical column to see 80 characters
set signcolumn=yes                      " enable error-column
set laststatus=2                        " No statusbar because airline but now lightline so 2 and not 0
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
set undodir=~/.vim/undodir
set undofile

" NetRW sets
let g:netrw_browse_split=0              " open in same window
let g:netrw_banner=0                    " disable annoying banner
let g:netrw_altv=1                      " open splits to the right
let g:netrw_winsize=75                  " when pressing v/t have the new split be 75% of the whole screen
let g:newrw_localrmdir='rm -r'

" #############################################################################
" Vim Plug Installation
" #############################################################################

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
\| endif

" #############################################################################
" Plugin Installation
" #############################################################################
call plug#begin('~/.vim/plugged')

" Plug 'gruvbox-community/gruvbox'        " colorscheme
Plug 'sonph/onehalf', { 'rtp': 'vim'  } " like atoms one but 1/2
Plug 'tpope/vim-fugitive'               " to work with git
Plug 'tpope/vim-commentary'             " fast comments
Plug 'itchyny/lightline.vim'            " statusline
Plug 'mbbill/undotree'                  " undo history
Plug 'ctrlpvim/ctrlp.vim'               " fuzzy finder
Plug 'jiangmiao/auto-pairs'             " autoclose brackets
Plug 'tweekmonster/startuptime.vim'     " check startuptime

call plug#end()

" #############################################################################
" Plugin Settings
" #############################################################################

" Colorscheme
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8e = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_invert_selection='0'
" colorscheme gruvbox
" set background=dark

colorscheme onehalfdark

" Make the background transparent
highlight Normal ctermbg=NONE guibg=NONE

" CtrlP configs
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

" Lightline
let g:lightline = {
      \ 'colorscheme': 'onehalfdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" #############################################################################
" REMAPS
" #############################################################################

" SET LEADER KEY
let mapleader = " "

" Disable Q coz useless
nnoremap <silent> Q <nop>
" Source .vimrc
nnoremap <silent> <Leader><CR> :so ~/.vimrc<CR>

" Easier movement between vim windows
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Better quality of life
vnoremap < <gv
vnoremap > >gv

" Navigate buffers
nnoremap <silent> <S-l> :bnext<CR>
nnoremap <silent> <S-h> :bprevious<CR>

" Resizing
" Use Ctrl + arrows to resize windows
nnoremap <silent> <C-Up> :resize -5<CR>
nnoremap <silent> <C-Down> :resize +5<CR>
nnoremap <silent> <C-Left> :vertical resize -5<CR>
nnoremap <silent> <C-Right> :vertical resize +5<CR>

" Vim-fugitive remaps
" git status
nnoremap <silent> <leader>gs :G<CR>
" resolve conflicts when merging branches
" nnoremap <leader>gj :diffget //3<CR>
" nnoremap <leader>gf :diffget //2<CR>

" Project View
nnoremap <silent> <leader>pv :Ex<CR>
" Open Undotree
nnoremap <leader>u :UndotreeToggle<CR>

" Start a Project Search
nnoremap <leader>ps :Rg<SPACE>

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

" Move higlighted lines up and down a line
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Yank not hurting registry
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Yank whole file
nnoremap <leader>Y gg"+yG

" Helpful delete into blackhole buffer
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" When replacing a higlighted text, don't yank it
vnoremap "_dP

" Esc is too far and I don't like <C-[>
" Normal, Visual, Select, Operator-pending
noremap <C-c> <esc>
" Insert, Command-line, Lang-Arg
lnoremap <C-c> <esc>

" Disable arrow keys to learn vim movement
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" IDE STUFF
" Check the filetype to know how to run the file
if &filetype ==# "python"
    " python
    nnoremap <silent> <C-b> :w <bar> :! python3 % <cr>
elseif &filetype ==# "sh"
    " bash, shell, zsh -> all will run in bash coz why not
    nnoremap <silent> <C-b> :w <bar> :! bash % <cr>
else
    " other executables
    nnoremap <silent> <C-b> :w <bar> :! ./% <cr>
endif

" #############################################################################
" Autocommands
" #############################################################################

" Delete useless spaces
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup trimclain
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
