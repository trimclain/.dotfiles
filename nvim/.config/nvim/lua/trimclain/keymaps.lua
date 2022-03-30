local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Remap space as a leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO: how to write this in lua (~ isn't recognized)
vim.cmd "nnoremap <silent> <Leader><CR> :so ~/.config/nvim/init.lua<CR>"

-- Easier movement between vim windows
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- Resizing: Use Ctrl + arrows to resize windows
keymap("n", "<C-Up>", ":resize -5<cr>", opts)
keymap("n", "<C-Down>", ":resize +5<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<cr>", opts)

-- Vim-fugitive
keymap("n", "<leader>gs", ":G<cr>", opts) -- git status
-- resolve conflicts when mergin branches (not used)
-- keymap("n", "<leader>gj", ":diffget //3<cr>", opts)
-- keymap("n", "<leader>gf", ":diffget //2<cr>", opts)

-- Project View (File Explorer)
-- keymap("n", "<leader>pv", ":Lex 30<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Undotree
keymap("n", "<leader>u", ":UndotreeToggle<cr>", opts)

-- QuickFixList Stuff - local ones not in use
QFLIST_LOCAL = 0
QFLIST_GLOBAL = 0

-- function ToggleQFList()
--
-- end
-- Very Useful Stuff
keymap("n", "Q", "", opts) -- disable Q coz useless
keymap("n", "<cr>", ":noh<cr>", opts) -- disable the higlighting of the searched text
keymap("n", "Y", "y$", opts) -- make Y work like C and D
-- keymap("n", "<C-u>", "<C-u>zz", opts)       -- keep it centered moving up
-- keymap("n", "<C-d>", "<C-d>zz", opts)       -- and down half a page
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
keymap("n", "<leader>Y", 'gg"+yG', opts) -- yank whole file
keymap("n", "<leader>y", '"+y', opts) -- yank not hurting
keymap("v", "<leader>y", '"+y', opts) -- the registers
keymap("n", "<leader>d", '"_d', opts) -- delete into
keymap("v", "<leader>d", '"_d', opts) -- blackhole buffer

-- Jumplist mutations: when you do 15j in normal mode and than C-o, it wouldn't
-- do 15k for you. With next remaps you modify your Jumplist (used by C-o and C-i)
-- to add break points every time you jump more than 5 lines up or down.
-- Maybe I'll rewrite this in lua someday
vim.cmd [[nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k']]
vim.cmd [[nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j']]

-- Telescope keybindings
-- with next command search for the word under the cursor
vim.keymap.set(
    "n",
    "<leader>pw",
    ':lua require("telescope.builtin").grep_string { search = vim.fn.expand("<cword>") }<CR>',
    opts
)
vim.keymap.set("n", "<leader>ps", ":lua require('telescope.builtin').live_grep()<CR>", opts)
vim.keymap.set("n", "<C-f>", ":lua require('trimclain.telescope').curr_buf_search()<CR>", opts)
vim.keymap.set("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>", opts)

vim.keymap.set("n", "<leader>gh", ":lua require('telescope.builtin').help_tags()<CR>", opts)
vim.keymap.set("n", "<leader>gk", ":lua require('telescope.builtin').keymaps()<CR>", opts)
vim.keymap.set("n", "<leader>gl", ":lua require('telescope.builtin').git_commits()<CR>", opts)
vim.keymap.set("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>", opts)

vim.keymap.set("n", "<leader>pf", ":Telescope find_files<cr>", opts)
vim.keymap.set("n", "<leader>phf", ":Telescope find_files hidden=true<cr>", opts)
vim.keymap.set("n", "<leader>pb", ":Telescope buffers<cr>", opts)
vim.keymap.set("n", "<leader>of", ":Telescope oldfiles<cr>", opts)

vim.keymap.set("n", "<leader>vrc", ":Telescope git_files cwd=~/.dotfiles<cr>", opts)
vim.keymap.set("n", "<leader>f;", ":Telescope commands<cr>", opts)

-- Esc is too far and I don't like <C-[>, make <C-c> work as <Esc> in every mode
keymap("", "<C-c>", "<Esc>", opts) -- normal, visual, select, operator-pending modes
keymap("l", "<C-c>", "<Esc>", opts) -- insert, command-line, lang-arg modes
keymap("i", "<C-c>", "<Esc>", opts) -- insert mode again, coz doesn't work above

-- Run a file
keymap("n", "<C-b>", ":w <bar> :! ./%<cr>", opts)

-- " QuickFixList Stuff (from Prime, rewritten in lua) - local ones not in use
keymap("n", "<leader>qj", ":cnext<CR>zz", opts)
keymap("n", "<leader>qk", ":cprev<CR>zz", opts)
-- keymap("n", "<leader>j", ":lnext<CR>zz", opts)
-- keymap("n", "<leader>k", ":lprev<CR>zz", opts)
keymap("n", "<C-q>", "<cmd>lua require('trimclain.keymaps').ToggleQFList(1)<CR>", opts)
-- keymap("n", "<leader>q", "<cmd>lua require('trimclain.keymaps').ToggleQFList(0)<CR>", opts)

vim.g.qflist_local = 0
vim.g.qflist_global = 0

local M = {}
M.ToggleQFList = function(global)
    if global then
        if vim.g.qflist_global == 1 then
            vim.g.qflist_global = 0
            vim.cmd "cclose"
        else
            vim.g.qflist_global = 1
            vim.cmd "copen"
        end
    else
        if vim.g.qflist_local == 1 then
            vim.g.qflist_local = 0
            vim.cmd "lclose"
        else
            vim.g.qflist_local = 1
            vim.cmd "lopen"
        end
    end
end

return M
