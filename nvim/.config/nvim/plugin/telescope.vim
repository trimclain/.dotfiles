" #############################################################################
" Telescope Mappings
" #############################################################################

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>gh :lua require('telescope.builtin').help_tags()<CR>

nnoremap <leader>pf :Telescope find_files <cr>
nnoremap <leader>phf :Telescope find_files hidden=true <cr>
nnoremap <leader>pb :Telescope buffers <cr>

nnoremap <leader>fdf :Telescope git_files cwd=~/.dotfiles <cr>
nnoremap <leader>f; :Telescope commands <cr>
