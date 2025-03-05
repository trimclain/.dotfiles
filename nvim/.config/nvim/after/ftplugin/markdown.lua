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

---Detects if a string starts with whitespaces and returns the length of them.
---@param str string The string to check.
---@return integer|nil The length of the leading whitespaces, nil if no leading whitespaces.
local function get_leading_whitespaces_length(str)
    local length = string.len(str)
    for i = 1, length do
        local char = string.sub(str, i, i)
        -- find a non-whitespace character
        if char:match("%S") then
            return i - 1
        end
    end
    -- if the string contains only whitespaces or is empty
    return nil
end

--- Check/uncheck the checkbox or convert the list item into the checkbox in current line
local toggle_checkbox = function()
    local line = vim.api.nvim_get_current_line()
    local leading_whitespace_length = get_leading_whitespaces_length(line)

    if leading_whitespace_length == nil then
        return
    end

    local trimmed_line = string.sub(line, leading_whitespace_length + 1)
    if vim.startswith(trimmed_line, "- [ ] ") then
        trimmed_line = "- [x] " .. string.sub(trimmed_line, 7)
    elseif vim.startswith(trimmed_line, "- [x] ") then
        trimmed_line = "- [ ] " .. string.sub(trimmed_line, 7)
    elseif vim.startswith(trimmed_line, "- ") then
        trimmed_line = "- [ ] " .. string.sub(trimmed_line, 3)
    else
        return
    end

    vim.api.nvim_set_current_line(string.rep(" ", leading_whitespace_length) .. trimmed_line)
end
vim.keymap.set("n", "<C-s>", toggle_checkbox, opts)

vim.keymap.set("i", "--", "—", opts)
