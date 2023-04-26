local preview_pdf = function()
    local filename = vim.fn.expand("%:r")
    local pdf = filename .. ".pdf"
    vim.cmd("!xdg-open " .. pdf .. " &")
    vim.notify("Opened " .. pdf, vim.log.levels.INFO, { title = "PDF Preview" })
end

vim.keymap.set("n", "<leader>mp", preview_pdf, { noremap = true, silent = true, desc = "Open pdf preview" })
