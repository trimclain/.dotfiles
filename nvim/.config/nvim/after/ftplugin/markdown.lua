vim.opt_local.colorcolumn = "120"

local opts = { noremap = true, silent = true }

vim.g.is_todo_list = false
local toggle_todo_list = function()
    if vim.g.is_todo_list == false then
        vim.keymap.set("i", "<cr>", "<cr>-   [ ] ", opts)
        vim.g.is_todo_list = true
        vim.notify "Enabled TODO List"
    else
        vim.keymap.del("i", "<cr>")
        vim.g.is_todo_list = false
        vim.notify "Disabled TODO List"
    end
end

vim.keymap.set("n", "<leader>td", toggle_todo_list, opts)
vim.keymap.set("i", "--", "—", { noremap = true })
