" #############################################################################
" REMAPS
" #############################################################################

" Disable Q coz useless
nnoremap <silent> Q <nop>
" Source init.vim
nnoremap <silent> <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Easier movement between vim windows
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Vim-fugitive remaps
" git status
nnoremap <silent> <leader>gs :G<CR>
" resolve conflicts when merging branches
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>

" Project View
nnoremap <silent> <leader>pv :Ex<CR>
" Undotree
nnoremap <silent> <leader>u :UndotreeShow<CR>

" Resizing
" Use alt + hjkl to resize windows
nnoremap <silent> <M-j> :resize -5<CR>
nnoremap <silent> <M-k> :resize +5<CR>
nnoremap <silent> <M-h> :vertical resize -5<CR>
nnoremap <silent> <M-l> :vertical resize +5<CR>


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
noremap <C-c> <esc>
" Insert, Command-line, Lang-Arg
lnoremap <C-c> <esc>

if has('nvim')
    " Open terminal in right vertical split
    nnoremap <silent> <leader>tt <C-w>v<C-w>l :terminal <cr>
    " Make esc leave terminal mode
    tnoremap <leader><Esc> <C-\><C-n>
    tnoremap <Esc><Esc> <C-\><C-n>
endif

" save and run python code
nnoremap <silent> <C-b> :w <bar> :! python3 % <cr>
