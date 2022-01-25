" #############################################################################
" Telescope Configs and Remaps
" #############################################################################

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" TODO: what is this next line
" nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>gh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>gk :lua require('telescope.builtin').keymaps()<CR>
nnoremap <leader>gl :lua require('telescope.builtin').git_commits()<CR>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<CR>

nnoremap <leader>pf :Telescope find_files <cr>
nnoremap <leader>phf :Telescope find_files hidden=true <cr>
nnoremap <leader>pb :Telescope buffers <cr>

nnoremap <leader>vrc :Telescope git_files cwd=~/.dotfiles <cr>
nnoremap <leader>f; :Telescope commands <cr>
