-- Use a protected call so we don't error out on first use
local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
    vim.notify "catppuccin not found!"
    return
end

-- configure it
catppuccin.setup {
    transparent_background = true,
    term_colors = false,
    styles = {
        comments = "italic",
        -- functions = "italic",
        functions = "NONE",
        -- keywords = "italic",
        keywords = "NONE",
        strings = "NONE",
        -- variables = "italic",
        variables = "NONE",
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = "italic",
                hints = "italic",
                warnings = "italic",
                information = "italic",
            },
            underlines = {
                errors = "underline",
                hints = "underline",
                warnings = "underline",
                information = "underline",
            },
        },
        lsp_trouble = false,
        cmp = true,
        lsp_saga = false,
        gitgutter = false,
        gitsigns = true,
        telescope = true,
        nvimtree = {
            enabled = true,
            show_root = false, -- makes the root folder not transparent
            transparent_panel = true, -- make the panel transparent
        },
        which_key = false,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        dashboard = true,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = true,
        markdown = true,
        lightspeed = false,
        ts_rainbow = false,
        hop = false,
        notify = true,
        telekasten = true,
    },
}
