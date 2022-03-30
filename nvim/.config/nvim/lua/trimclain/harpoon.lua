local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
    return
end

harpoon.setup {
    global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,

        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,

        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
        enter_on_sendcmd = false,

        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,

        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },

        -- set marks specific to each git branch inside git repository
        mark_branch = false,
    },
}

-- Keymaps

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", opts)
keymap("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)

-- NOTE: ideally jkl; should be used with ctrl
keymap("n", "<C-j>", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
keymap("n", "<C-k>", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
-- keymap("n", "<C-n>", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
-- keymap("n", "<C-s>", ":lua require('harpoon.ui').nav_file(4)<CR>", opts)
