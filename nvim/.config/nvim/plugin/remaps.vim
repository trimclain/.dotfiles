" #############################################################################
" Remaps
" #############################################################################

" Disable Q coz useless
nnoremap <silent> Q <nop>
" Source init.vim
nnoremap <silent> <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Nice: disable higlighted text after done with search
nnoremap <silent> <CR> :noh <CR>

" Easier movement between vim windows
" Can't use ALT+{h,j,k,l} to switch windows coz of i3 so back old movement
tnoremap <leader>h <C-\><C-N><C-w>h
tnoremap <leader>j <C-\><C-N><C-w>j
tnoremap <leader>k <C-\><C-N><C-w>k
tnoremap <leader>l <C-\><C-N><C-w>l
" Can't do that with leader keys
" inoremap <leader>h <C-\><C-N><C-w>h
" inoremap <leader>j <C-\><C-N><C-w>j
" inoremap <leader>k <C-\><C-N><C-w>k
" inoremap <leader>l <C-\><C-N><C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Navigate buffers
nnoremap <silent> <leader>bn :bnext<CR>
nnoremap <silent> <leader>bp :bprevious<CR>

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
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>

" Project View
nnoremap <silent> <leader>pv :Ex<CR>
" nnoremap <silent> <leader>pv :NERDTreeToggle<CR>
" Undotree
nnoremap <silent> <leader>u :UndotreeShow<CR>

" Make Y work like C and D
nnoremap Y y$

" PRIME JUICERS
" Keeping it centered when going to next on search and when joining lines
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Move higlighted lines up and down a line
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" no idea what this does but it sure does smth
" vnoremap <leader>p "_dP

" Yank not hurting registry
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Yank whole file
nnoremap <leader>Y gg"+yG

" Helpful delete into blackhole buffer
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" END OF PRIME JUICERS

" Esc is too far and I don't like <C-[>
" Normal, Visual, Select, Operator-pending
noremap <C-c> <Esc>
" Insert, Command-line, Lang-Arg
lnoremap <C-c> <Esc>
" lnoremap didn't set this for insert mode so i have to
inoremap <C-c> <Esc>

if has('nvim')
    " Open terminal in right vertical split
    nnoremap <silent> <leader>tt <C-w>v<C-w>l :terminal <cr>
    " Make esc leave terminal mode
    tnoremap <leader><Esc> <C-\><C-n>
    tnoremap <Esc><Esc> <C-\><C-n>
endif

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
