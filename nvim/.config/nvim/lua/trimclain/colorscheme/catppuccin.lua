-- Use a protected call so we don't error out on first use
local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
    vim.notify "catppuccin not found!"
    return
end

-- configure it
catppuccin.setup {
    transparent_background = false,
    term_colors = false,
    compile = {
        enabled = false,
        path = vim.fn.stdpath "cache" .. "/catppuccin",
    },
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
        cmp = true,
        gitsigns = true,
        telescope = true,
        nvimtree = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        bufferline = true, -- todo
        markdown = true,
        hop = false,
        navic = {
            enabled = false,
            custom_bg = "NONE",
        },
    },
    color_overrides = {},
    highlight_overrides = {},
}
