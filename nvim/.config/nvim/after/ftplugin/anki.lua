-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }
local keymap = vim.keymap.set

-- add german letters
keymap("i", "ue", "ü", opts)
keymap("i", "ae", "ä", opts)
keymap("i", "oe", "ö", opts)
keymap("i", "sz", "ß", opts)

-- cut on save
local anki = vim.api.nvim_create_augroup("trimclain_anki", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.anki", "ankitemp" },
    command = "silent %d+",
    desc = "Cut Entire File Into Clipboard",
    group = anki,
})

-- decrease timeoutlen (time in milliseconds to wait for a mapped sequence to complete) to make it less annoying
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = { "*.anki", "ankitemp" },
    command = "set timeoutlen=100",
    desc = "Set timeoutlen for anki files",
    group = anki,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = { "*.anki", "ankitemp" },
    command = "set timeoutlen=500",
    desc = "Restore timeoutlen for other files",
    group = anki,
})
