-- undo tree
return {
    {
        "mbbill/undotree",
        enabled = vim.fn.executable("diff") == 1, -- windows issues
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
        },
    },
}
