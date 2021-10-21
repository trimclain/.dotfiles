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
" Vim Plug Installation
" #############################################################################

" Install vim-plug if not found and Run PlugInstall
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
\| endif

" #############################################################################
" Plugin Installation
" #############################################################################
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-commentary'             " easy commenting, thanks tpope
Plug 'tpope/vim-fugitive'               " vim git integration, thanks tpope
Plug 'tpope/vim-surround'               " easy surrounding, thanks tpope
Plug 'mbbill/undotree'                  " see the undo history
Plug 'dstein64/vim-startuptime'         " check the startuptime of plugins
" Plug 'preservim/nerdtree'               " nice file tree

" Status Lines
 Plug 'itchyny/lightline.vim'           " lightweight and cool
" Plug 'vim-airline/vim-airline'          " nice but too laggy
" Plug 'hoob3rt/lualine.nvim'             " to try sometime 1
" Plug 'glepnir/galaxyline.nvim', {'branch': 'main'}  " to try sometime 2

" Colorschemes
Plug 'gruvbox-community/gruvbox'        " pretty cool colorscheme, thanks prime
" Plug 'arzg/vim-colors-xcode'            " fun pink colorscheme, thanks bashbunni
" Plug 'dracula/vim', { 'as': 'dracula' } " dracula-theme
" Plug 'rakr/vim-one'                     " one-dark theme from Atom
" Plug 'phanviet/vim-monokai-pro'         " vim-monokai-pro from Sublime
" Plug 'kyoz/purify', { 'rtp': 'vim' }    " purify theme, thanks bashbunni

" LSP
Plug 'neovim/nvim-lspconfig'            " LSP configurations
Plug 'kabouzeid/nvim-lspinstall'        " add LspInstall <language>
Plug 'hrsh7th/nvim-compe'               " Autocomplete 1
" Plug 'nvim-lua/completion-nvim'         " Autocomplete 2
Plug 'glepnir/lspsaga.nvim'             " live error finder

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Updating the parsers on update

" Initialize plugin system
call plug#end()

" #############################################################################
" Plugin Settings
" #############################################################################

" Colorscheme

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8e = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" ================== CHOOSE ONE ===================
" gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox
set background=dark

" vim-colors-xcode
" colorscheme xcodedarkhc
" set background=dark

" dracula-theme
" colorscheme dracula

" one-dark theme
" colorscheme one
" set background=dark

" vim-monokai-pro
" colorscheme monokai_pro

" purify theme
" colorscheme purify

" =================================================

" Make the background transparent
highlight Normal ctermbg=NONE guibg=NONE

" Require Lsp and the rest of Lua files
lua require("trimclain")

" Enable Treesitter
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}

" No idea if this is still needed
if executable('rg')
    let g:rg_derive_root='true'
endif

" Airline
" let g:airline_powerline_fonts = 1           " force using powerline-fonts

" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" Other Lets
let loaded_matchparen = 1                   " disable highlighting matching parentesis

" #############################################################################

" SET LEADER KEY
let mapleader = " "

" Juicers
com! Q q
com! W w
com! X x

" #############################################################################

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
