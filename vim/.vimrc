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
set completeopt=menu,menuone,noselect   " list of options for Insert mode completion
" set termguicolors                       " when on, uses |highlight-guifg| and |highlight-guibg| attributes in the terminal (thus using 24-bit color)
set nowrap                              " pretty clear
set noshowmode                          " we don't need to see things like -- INSERT -- anymore
set showmatch                           " when you enter a close-bracket, the cursor briefly jumps to the matching open-bracket
set textwidth=0                         " disable breaking the long line of the paste
set wrapmargin=0                        " simply don't wrap the text (distance from the right border = 0)
set number                              " enable line numbering
set relativenumber                      " show relative line numbers
set numberwidth=4                       " set number column width (default: 4)
set hlsearch                            " highlight all matches on previous search pattern
set incsearch                           " go to search while typing
set ignorecase                          " use case insensitive search
set smartcase                           " except when using capital letters
set hidden                              " allows to open multiple buffers
set ruler                               " Show the line and column number of the cursor position in the bottom right
set backspace=indent,eol,start          " make sure backspace works properly
set scrolloff=4                         " start scrolling when 8 lines away from the bottom
set sidescrolloff=8                     " or  8 chars away from the sides
set wildmenu                            " better command-line completion
set showcmd                             " show partial commands in the last line of the screen
set colorcolumn=80                      " vertical column to see 80 characters
set signcolumn=yes                      " enable error-column
set updatetime=50                       " after this many milliseconds of not writing anything the swap file will be written, default 4000 is too long
set timeoutlen=500                      " time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
set clipboard+=unnamedplus              " allows vim to access the system clipboard
set autoindent                          " make
set smartindent                         " indenting
set smarttab                            " smarter
set expandtab                           " use spaces instead of tabs
set tabstop=4 softtabstop=4             " insert 4 spaces for \t and for <Tab> and <BS> keypresses
set shiftwidth=4                        " the number of spaces inserted for each indentation level
set nobackup                            " creates a backup file
set noswapfile                          " creates a swapfile
set undofile                            " enables persistent undo
set undodir=~/.vim/undodir              " set the undo directory
set conceallevel=0                      " so that `` is visible in markdown files (default: 0)
set laststatus=2                        " no statusbar because lightline
set showtabline=2                       " enable tabline to see buffers using plugins
" set splitright                          " force all vertical splits to go to the right of current window
" set mouse=a                             " enable the mouse
" set cursorline                          " highlight current line

" Enable completions using omnifunc
set omnifunc=syntaxcomplete#Complete

" Disable ALL sounds and errorbells
set noerrorbells
set visualbell
set t_vb=
set tm=500

let loaded_matchparen = 1               " if the cursor is over a bracket, its matching partner is highlighted (1 - disabled)

" NetRW sets
let g:netrw_altfile=1                   " CTRL-^ will return to the last edited file
let g:netrw_altv=1                      " open splits to the right
let g:netrw_banner=0                    " disable annoying banner
let g:netrw_browse_split=4              " act like 'P' (ie. open previous window)
let g:netrw_hide=0                      " show all files
let g:netrw_sizestyle='h'               " show human-readable size (1000 base)
let g:newrw_localrmdir='rm -r'          " remove directory command (default was rmdir)

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
" Plug 'sainnhe/sonokai'                  " other colorscheme
Plug 'sonph/onehalf', { 'rtp': 'vim'  } " like atoms one but 1/2

Plug 'tpope/vim-fugitive'                " git
Plug 'tpope/vim-commentary'              " comments
Plug 'itchyny/lightline.vim'             " statusline
Plug 'mengelbrecht/lightline-bufferline' " bufferline
Plug 'moll/vim-bbye'                     " delete buffers and close files without closing your windows
Plug 'mbbill/undotree'                   " undo history
Plug 'ctrlpvim/ctrlp.vim'                " fuzzy finder
Plug 'vim-scripts/AutoComplPop'          " the easiest to install autocomple
Plug 'jiangmiao/auto-pairs'              " autoclose brackets
Plug 'tweekmonster/startuptime.vim'      " check startuptime

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

set background=dark
colorscheme onehalfdark
" colorscheme sonokai

" Make the background transparent
highlight Normal ctermbg=NONE guibg=NONE

" Lightline
let g:lightline = {
      \ 'colorscheme': 'onehalfdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ [ ] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" CtrlP configs
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

" AutoPairs configs
" The default pairs is {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" You could also define multibyte pairs such as <!-- -->, <% %> and so on
let g:AutoPairsMapBS=0          " disable BS remap

" #############################################################################
" REMAPS
" #############################################################################

" SET LEADER KEY
let mapleader = " "

" To exit vim and save files faster
nnoremap <silent> Q :qa<cr>
nnoremap <silent> <leader>q :Bdelete<cr>
nnoremap <silent> <leader>w :w<cr>

" Please disable hlsearch on redraw like neovim
nnoremap <c-l> :nohlsearch<cr><c-l>

" Source .vimrc
nnoremap <silent> <leader><cr> :so ~/.vimrc<cr>

" Easier movement between vim windows
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Better quality of life
vnoremap < <gv
vnoremap > >gv

" Navigate buffers
nnoremap <silent> <S-l> :bnext<cr>
nnoremap <silent> <S-h> :bprevious<cr>

" Resizing
" Use Ctrl + arrows to resize windows
nnoremap <silent> <C-Up> :resize -5<cr>
nnoremap <silent> <C-Down> :resize +5<cr>
nnoremap <silent> <C-Left> :vertical resize -5<cr>
nnoremap <silent> <C-Right> :vertical resize +5<cr>

" Use Ctrl + Space to open completion menu
inoremap <C-@> <C-x><C-o>

" Use tab to scroll throug completion options only when a popup windwo is open
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Vim-fugitive remaps
" git status
nnoremap <silent> <leader>gs :G<cr>
" resolve conflicts when merging branches
" nnoremap <leader>gj :diffget //3<cr>
" nnoremap <leader>gf :diffget //2<cr>

" Toggle Netrw
let g:netrw_opened = 0
function! NetrwToggle()
    if g:netrw_opened == 1
        " get the amount of opened splits and move this much to left
        " hoping this would work
        " TODO:
        " execute 'wincmd ' . (tabpagewinnr(tabpagenr(), '$') - 1) . 'h'
        execute 'close'
    else
        " TODO:
        " let g:netrw_opened = 1
        execute '15Vex'
    endif
endfunction


" Explorer (make it toggle)
nnoremap <silent> <leader>e :call NetrwToggle()<cr>
" Open Undotree
nnoremap <silent> <leader>u :UndotreeToggle<cr>

" Start a Project Search
nnoremap <leader>fs :Rg<space>

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
inoremap = =<c-g>u
inoremap : :<c-g>u

" Move higlighted lines up and down a line
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" Yank not hurting registry
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Yank whole file
nnoremap <leader>Y gg"+yG

" Helpful delete into blackhole buffer
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" When replacing a higlighted text, don't yank it
vnoremap p "_dP

" Esc is too far and I don't like <C-[>
" Normal, Visual, Select, Operator-pending
noremap <C-c> <esc>
" Insert, Command-line, Lang-Arg
lnoremap <C-c> <esc>

" VERY IMPORTANT KEYBINDINGS
 " nnoremap <Up>          :echom "--> k <-- "<CR>
 " nnoremap <Down>        :echom "--> j <-- "<CR>
 " nnoremap <Right>       :echom "--> l <-- "<CR>
 " nnoremap <Left>        :echom "--> h <-- "<CR>

 " inoremap <Up>     <C-o>:echom "--> k <-- "<CR>
 " inoremap <Down>   <C-o>:echom "--> j <-- "<CR>
 " inoremap <Right>  <C-o>:echom "--> l <-- "<CR>
 " inoremap <Left>   <C-o>:echom "--> h <-- "<CR>

" -- Sometimes them fingers do be fat
com! Q q
com! Qa qa
" com! X x      " TODO: any workarounds?
com! W w

" #############################################################################
" Autocommands
" #############################################################################

" Delete useless spaces
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

" Check the filetype to know how to run the file
function! UpdateRunCommand()
    if &filetype ==# 'python'
        " python
        nnoremap <silent> <C-b> :w<cr> :!python3 %<cr>
    elseif &filetype ==# 'sh'
        " bash, shell, zsh -> all will run in bash coz why not
        nnoremap <silent> <C-b> :w<cr> :!bash %<cr>
    elseif &filetype ==# 'vim'
        " vim
        nnoremap <silent> <C-b> :w<cr> :source %<cr>
    else
        " other filetypes, need to be executable (TODO: write the check)
        nnoremap <silent> <C-b> :w <cr> :!./% <cr>
    endif
endfunction

" Close these filetypes with a single keypress instead of :q
function! UnlistBuffers()
    nnoremap <silent> <buffer> q :close<cr>
    nnoremap <silent> <buffer> <esc> :close<cr>
    set nobuflisted
endfunction

augroup trimclain
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
    autocmd BufEnter * :call UpdateRunCommand()
    autocmd FileType qf,help,netrw,fugitive :call UnlistBuffers()
augroup END

augroup autopairs
    autocmd!
    " disable most of the stuff for vim files
    au FileType vim let b:AutoPairs = {"(": ")"}
    au FileType php let b:AutoPairs = AutoPairsDefine({'<?' : '?>', '<?php': '?>'})
augroup END

" -- To see what the options are use :h fo-table
" vim.opt.formatoptions = vim.opt.formatoptions
"     - "a" -- Auto formatting is BAD.
"     - "t" -- Don't auto format my code. I got linters for that.
"     + "c" -- In general, I like it when comments respect textwidth
"     + "q" -- Allow formatting comments w/ gq
"     - "o" -- O and o, don't continue comments
"     + "r" -- But do continue when pressing enter.
"     + "n" -- Indent past the formatlistpat, not underneath it.
"     + "j" -- Auto-remove comments if possible.
"     - "2" -- I'm not in gradeschool anymore
augroup filetypeoptions
    autocmd!
    autocmd FileType * :setlocal formatoptions=cqrnj
augroup END

augroup netrw_toggle
    autocmd!
    autocmd FileType netrw let g:netrw_opened = 1
    autocmd FileType netrw autocmd BufWinEnter <buffer> let g:netrw_opened = 1
    autocmd FileType netrw autocmd BufWinLeave <buffer> let g:netrw_opened = 0
augroup END

" InsertChange or CursorMovedI
" augroup completion
"     autocmd!
"     autocmd CursorMovedI * startinsert | call feedkeys("\<C-x>\<C-o>")
" augroup END
