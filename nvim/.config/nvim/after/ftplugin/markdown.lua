vim.opt_local.colorcolumn = "120"

local opts = { noremap = true, silent = true }
local remap = function()
    vim.keymap.set("i", "<cr>", "<cr>- [ ] ", opts)
end
vim.keymap.set("n", "<leader>td", remap, opts)
