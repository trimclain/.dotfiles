" #############################################################################
" Lsp Options and Remaps
" #############################################################################

"" This all could be ported to lsp.lua using vim.o.completeopt etc.
set completeopt=menu,menuone,noselect        " required by lsp-cmp
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" LSP Remaps
" Used
nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vff :lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
" Not really used
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>vll :call LspLocationList()<CR>
