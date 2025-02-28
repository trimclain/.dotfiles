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

--- Check or uncheck the checkbox in current line
local toggle_checkbox = function()
    local line = vim.api.nvim_get_current_line()
    if vim.startswith(line, "- [ ] ") then
        vim.api.nvim_set_current_line("- [x] " .. string.sub(line, 7))
    elseif vim.startswith(line, "- [x] ") then
        vim.api.nvim_set_current_line("- [ ] " .. string.sub(line, 7))
    end
end
vim.keymap.set("n", "<C-s>", toggle_checkbox, opts)

vim.keymap.set("i", "--", "—", opts)
