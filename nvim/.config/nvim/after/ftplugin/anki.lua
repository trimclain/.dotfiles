-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }
local keymap = vim.keymap.set

-- decrease the timeout to make it less annoying
-- TODO: can I actually make this option only for one buffer? (restore it with autocommands?)
vim.opt_local.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)

keymap("i", "ue", "ü", opts)
keymap("i", "ae", "ä", opts)
keymap("i", "oe", "ö", opts)
keymap("i", "sz", "ß", opts)

-- TODO: find a way to enable lsp in .anki files for latex symbols completion
local anki = vim.api.nvim_create_augroup("trimclain_anki", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.anki",
    command = "silent %d+",
    desc = "Cut Entire File Into Clipboard",
    group = anki,
})
