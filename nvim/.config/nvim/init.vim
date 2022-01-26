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

" Run :PlugInstall if there are missing plugins
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
Plug 'windwp/nvim-autopairs'            " automatically close brackets
Plug 'google/vim-searchindex'           " show the number of matches
Plug 'tweekmonster/startuptime.vim'     " check the startuptime of plugins
Plug 'ap/vim-css-color'                 " preview colors in vim
" To preview HTML, CSS and JS files in browser
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
" To preview markdown files in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Status Line
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline
" Plug 'kyazdani42/nvim-web-devicons'

" Colorscheme
Plug 'catppuccin/nvim', {'as': 'catppuccin'} " teej told bash so I'm trying
" Plug 'sonph/onehalf', { 'rtp': 'vim' }    " like atoms one but 1/2
" Plug 'gruvbox-community/gruvbox'        " prime
" Plug 'arzg/vim-colors-xcode'            " xcode colorscheme
" Plug 'dracula/vim', { 'as': 'dracula' } " dracula-theme
" Plug 'rakr/vim-one'                     " one-dark theme from Atom
" Plug 'phanviet/vim-monokai-pro'         " monokai from Sublime
" Plug 'kyoz/purify', { 'rtp': 'vim' }    " purify theme

" LSP
Plug 'neovim/nvim-lspconfig'            " LSP configurations
Plug 'hrsh7th/nvim-cmp'                 " LSP Autocomplete Engine
Plug 'hrsh7th/cmp-buffer'               " autocomplete from buffer
Plug 'hrsh7th/cmp-path'                 " autocomplete path to files
Plug 'hrsh7th/cmp-nvim-lsp'             " get autoimport on complete and more
Plug 'L3MON4D3/LuaSnip'                 " snippets, needed for nvim-cmp to autocomplete
Plug 'onsails/lspkind-nvim'             " add vscode-like pictograms to LSP
Plug 'williamboman/nvim-lsp-installer'  " add LspInstall <language>

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Treesitter (Install Languages with :TSInstall <languages>)
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Initialize plugin system
call plug#end()

" #############################################################################

" Load all Lua Config Files through init.lua
lua require("trimclain")

" SET LEADER KEY
nnoremap <Space> <Nop>
let mapleader = " "

" #############################################################################
" Autocommands
" #############################################################################

" Empty all Registers
fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

" Delete useless spaces
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" highlight when yanking
augroup lua_highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({
        \ higroup = "Substitute",
        \ timeout = 100,
        \ on_macro = true
        \ })
augroup END

augroup trimclain
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
