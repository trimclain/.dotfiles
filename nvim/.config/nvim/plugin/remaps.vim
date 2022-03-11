" #############################################################################
" Remaps
" #############################################################################

" TODO: rewrite this in lua, also use https://rafaelleru.github.io/blog/quickfix-autocomands/
" QuickFixList Stuff - local ones not in use
nnoremap <C-j> :cnext<CR>zz
nnoremap <C-k> :cprev<CR>zz
" nnoremap <leader>k :lnext<CR>zz
" nnoremap <leader>j :lprev<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>
" nnoremap <leader>q :call ToggleQFList(0)<CR>

let g:qflist_local = 0
let g:qflist_global = 0

fun! ToggleQFList(global)
    if a:global
        if g:qflist_global == 1
            let g:qflist_global = 0
            cclose
        else
            let g:qflist_global = 1
            copen
        end
    else
        if g:qflist_local == 1
            let g:qflist_local = 0
            lclose
        else
            let g:qflist_local = 1
            lopen
        end
    endif
endfun
