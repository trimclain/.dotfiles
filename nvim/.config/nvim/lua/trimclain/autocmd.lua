-- #############################################################################
-- Autocommands
-- #############################################################################

-- TODO: rewrite this in lua
vim.cmd [[
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
]]
