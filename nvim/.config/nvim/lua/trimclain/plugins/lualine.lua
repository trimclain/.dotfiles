M = {}

local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
    return
end

-- Show shiftwidth length
local spaces = function()
    return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- Show if formatting on save is enabled
local autoformat = function()
    return vim.g.autoformat_status
end

local hide_in_width = function()
    return vim.o.columns > 80
end

-- thnaks chris@machine
local language_server = {
    function()
        local buf_ft = vim.bo.filetype
        local ui_filetypes = {
            "help",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "DressingSelect",
            "TelescopePrompt",
            "lspinfo",
            "lsp-installer",
            "",
        }

        if vim.tbl_contains(ui_filetypes, buf_ft) then
            if M.language_servers == nil then
                return ""
            else
                return M.language_servers
            end
        end

        local clients = vim.lsp.buf_get_clients()
        local client_names = {}

        -- add client
        for _, client in pairs(clients) do
            if client.name ~= "null-ls" then
                table.insert(client_names, client.name)
            end
        end

        -- add formatter
        local s = require "null-ls.sources"
        local available_sources = s.get_available(buf_ft)
        local registered = {}
        for _, source in ipairs(available_sources) do
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end

        local formatter = registered["NULL_LS_FORMATTING"]
        local linter = registered["NULL_LS_DIAGNOSTICS"]
        if formatter ~= nil then
            vim.list_extend(client_names, formatter)
        end
        if linter ~= nil then
            vim.list_extend(client_names, linter)
        end

        -- join client names with commas
        local client_names_str = table.concat(client_names, ", ")

        -- check client_names_str if empty
        local language_servers = ""
        local client_names_str_len = #client_names_str
        if client_names_str_len ~= 0 then
            language_servers = "LSP: " .. client_names_str .. ""
        end

        if client_names_str_len == 0 then
            return ""
        else
            M.language_servers = language_servers
            return language_servers:gsub(", anonymous source", "")
        end
    end,
    -- padding = 0,
    cond = hide_in_width,
    component_separators = "",
}

local move_to_the_middle = {
    function()
        return "%="
    end,
    component_separators = "",
}

lualine.setup {
    options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        -- component_separators = { " ", " " },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- disabled_filetypes = { "dashboard" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { move_to_the_middle, language_server },
        -- lualine_c = {},
        lualine_x = { "encoding", spaces, "fileformat", "filetype", autoformat },
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
