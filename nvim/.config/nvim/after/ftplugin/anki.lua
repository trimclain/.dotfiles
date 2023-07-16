-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }

-- decrease the timeout to make it less annoying
-- TODO: can I actually make this option only for one buffer?
vim.opt_local.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)

vim.keymap.set("i", "ue", "ü", opts)
vim.keymap.set("i", "ae", "ä", opts)
vim.keymap.set("i", "oe", "ö", opts)
vim.keymap.set("i", "sz", "ß", opts)
