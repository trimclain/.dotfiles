vim.opt_local.colorcolumn = "120"
vim.opt_local.textwidth = 120

-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }

vim.b.todo_list_bufnr = vim.fn.bufnr()
vim.b.is_todo_list = false

--- Toggle writing TODO lists in current markdown buffer
local toggle_inserting_checkboxes = function()
    if vim.b.is_todo_list == false then
        vim.keymap.set("i", "<cr>", "<cr>- [ ] ", { buffer = vim.b.todo_list_bufnr })
        vim.b.is_todo_list = true
        vim.notify("Enabled TODO List")
    else
        vim.keymap.del("i", "<cr>", { buffer = vim.b.todo_list_bufnr })
        vim.b.is_todo_list = false
        vim.notify("Disabled TODO List")
    end
end
vim.keymap.set("n", "<leader>td", toggle_inserting_checkboxes, opts)


vim.keymap.set("i", "--", "—", opts)
