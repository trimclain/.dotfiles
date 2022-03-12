-- #############################################################################
-- Telescope Setup
-- #############################################################################

require('telescope').setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        -- if no nerdfont:
        -- borderchars = { '-', '|', '-', '|', '$', '$', '$', '$' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    }
}
require('telescope').load_extension('fzy_native')

-- #############################################################################
-- Remaps
-- #############################################################################

vim.keymap.set("n", "<leader>ps", ":lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>")
-- TODO: what is this next line
-- vim.keymap.set("n", "<leader>pw", ":lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>")
-- vim.keymap.set("n", "<leader>ps", ":lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>")

vim.keymap.set("n", "<leader>gh", ":lua require('telescope.builtin').help_tags()<CR>")
vim.keymap.set("n", "<leader>gk", ":lua require('telescope.builtin').keymaps()<CR>")
vim.keymap.set("n", "<leader>gl", ":lua require('telescope.builtin').git_commits()<CR>")
vim.keymap.set("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>")

vim.keymap.set("n", "<leader>pf", ":Telescope find_files <cr>")
vim.keymap.set("n", "<leader>phf", ":Telescope find_files hidden=true <cr>")
vim.keymap.set("n", "<leader>pb", ":Telescope buffers <cr>")

vim.keymap.set("n", "<leader>vrc", ":Telescope git_files cwd=~/.dotfiles <cr>")
vim.keymap.set("n", "<leader>f;", ":Telescope commands <cr>")
