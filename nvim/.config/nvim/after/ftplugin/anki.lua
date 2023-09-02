-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }
local keymap = vim.keymap.set

-- decrease the timeout to make it less annoying
-- TODO: can I actually make this option only for one buffer?
vim.opt_local.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)

keymap("i", "ue", "ü", opts)
keymap("i", "ae", "ä", opts)
keymap("i", "oe", "ö", opts)
keymap("i", "sz", "ß", opts)

local anki = vim.api.nvim_create_augroup("trimclain_anki", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.anki",
    command = "silent %y+",
    desc = "Yank Entire File",
    group = anki,
})
