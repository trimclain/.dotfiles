vim.opt_local.colorcolumn = "120"

-- TODO: can I make this buffer specific and not filetype specific?

-- local opts = { noremap = true, silent = true }
-- local bufnr = vim.fn.bufnr()

-- vim.g.is_todo_list = false
-- local toggle_todo_list = function()
--     if vim.g.is_todo_list == false then
--         vim.api.nvim_buf_set_keymap(bufnr, "i", "<cr>", "<cr>-   [ ] ", opts)
--         vim.g.is_todo_list = true
--         vim.notify "Enabled TODO List"
--     else
--         vim.api.nvim_buf_del_keymap(bufnr, "i", "<cr>")
--         vim.g.is_todo_list = false
--         vim.notify "Disabled TODO List"
--     end
-- end

-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>td", toggle_todo_list, opts)

vim.api.nvim_buf_set_keymap(0, "i", "--", "—", { noremap = true })
