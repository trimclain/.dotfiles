local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
    return
end

-- local gps_status_ok, gps = pcall(require, "nvim-gps")
-- if not gps_status_ok then
--     return
-- end

-- Show shiftwidth length
local spaces = function()
    return "tab:" .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- Show if formatting on save is enabled
local autoformat = function()
    return vim.g.autoformat_status
end

lualine.setup {
    options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        -- section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
        component_separators = { " ", " " },
        section_separators = { left = "", right = "" },
        -- disabled_filetypes = { "dashboard" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        -- lualine_c = { "%=", "filename" },
        lualine_c = {},
        lualine_x = { "encoding", spaces, autoformat, "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { "fugitive", "nvim-tree", "quickfix", "toggleterm" },
    -- winbar = {
    --     lualine_a = {},
    --     lualine_b = {},
    --     lualine_c = { "filename" },
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = {},
    -- },
    --
    -- inactive_winbar = {
    --     lualine_a = {},
    --     lualine_b = {},
    --     lualine_c = { "filename" },
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = {},
    -- },
}
