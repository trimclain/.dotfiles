local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Remap space as a leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--
-- Easier movement between buffers (I'm fine with arrows and <C-w>jk for now -> more keys for whichkey)
keymap("n", "<left>", "<C-w>h", opts)
keymap("n", "<right>", "<C-w>l", opts)
-- keymap("n", "<leader>j", "<C-w>j", opts)
-- keymap("n", "<leader>k", "<C-w>k", opts)

--
-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

--
-- Resizing: Use Ctrl + arrows to resize buffers
keymap("n", "<C-Up>", ":resize -5<cr>", opts)
keymap("n", "<C-Down>", ":resize +5<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<cr>", opts)

--
-- Vim-fugitive
-- resolve conflicts when merging branches (not used)
-- keymap("n", "<leader>gj", ":diffget //3<cr>", opts)
-- keymap("n", "<leader>gf", ":diffget //2<cr>", opts)

--
-- Very Useful Stuff
keymap("n", "Q", "<cmd>qa<cr>", opts) -- remap Q to :qa
keymap("n", "n", "nzzzv", opts) -- keep it centered when searching forward
keymap("n", "N", "Nzzzv", opts) -- and backwards
keymap("n", "J", "mzJ`z", opts) -- keep it centered when joining lines
keymap("i", ",", ",<c-g>u", opts) -- set a break point for undo after ,
keymap("i", ".", ".<c-g>u", opts) -- after .
keymap("i", "!", "!<c-g>u", opts) -- after !
keymap("i", "?", "?<c-g>u", opts) -- after ?
keymap("v", "K", ":m '<-2<cr>gv=gv", opts) -- move higlighted lines up a line
keymap("v", "J", ":m '>+1<cr>gv=gv", opts) -- and down a line
keymap("v", "<", "<gv", opts) -- stay in indent mode
keymap("v", ">", ">gv", opts) -- stay in indent mode
keymap("v", "y", "myy`y", opts) -- Maintain the cursor position
keymap("v", "Y", "myy`y", opts) -- when yanking a visual selection
keymap("v", "p", '"_dP', opts) -- when replacing a higlighted text, don't yank it
-- keymap("n", "<leader>y", '"+y', opts) -- yank into
-- keymap("v", "<leader>y", '"+y', opts) -- system clipboard (no need since I'm using clipboardplus)
keymap("i", "<C-r>", "<C-r>+", { noremap = true }) -- paste from clipboard in insert mode
keymap("c", "<C-r>", "<C-r>+", { noremap = true }) -- paste from clipboard in command mode

-- Thx JoosepAlviste
-- Open the file under the cursor with the default file handler for that file type (e.g., Firefox for `http` links, etc.)
-- This mapping normally comes from `netrw`, but we disabled that for nvim-tree
keymap("n", "gx", [[:call HandleURL()<cr>]], { silent = true })

--
-- Store relative line number jumps in the jumplist if they exceed a threshold.
keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- Telescope keybindings
keymap("n", "<C-f>", ":lua require('trimclain.plugins.telescope').curr_buf_search()<CR>", opts)
keymap("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>", opts)

-- Harpoon
keymap("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
keymap("n", "<C-j>", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
keymap("n", "<C-k>", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
-- keymap("n", "<C-n>", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
-- keymap("n", "<C-s>", ":lua require('harpoon.ui').nav_file(4)<CR>", opts)

-- hop.nvim keybindings
keymap(
    "",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    opts
)
keymap(
    "",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    opts
)
keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
    opts
)
keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>",
    opts
)

-- jaq.nvim
keymap("n", "<C-b>", ":Jaq<cr>", opts)

-- Esc is too far and I don't like <C-[>, make <C-c> work as <Esc> in every mode
keymap("", "<C-c>", "<Esc>", opts) -- normal, visual, select, operator-pending modes
keymap("l", "<C-c>", "<Esc>", opts) -- insert, command-line, lang-arg modes
keymap("i", "<C-c>", "<Esc>", opts) -- insert mode again, coz doesn't work above

--
-- " QuickFixList Stuff
keymap("n", "<up>", ":cprev<CR>zz", opts)
keymap("n", "<down>", ":cnext<CR>zz", opts)
keymap("n", "<C-q>", "<cmd>lua require('trimclain.utils').ToggleQFList()<CR>", opts)
