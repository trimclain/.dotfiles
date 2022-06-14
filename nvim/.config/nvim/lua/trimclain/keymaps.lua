local opts = { noremap = true, silent = true }

-- local keymap = vim.api.nvim_set_keymap
local keymap = vim.keymap.set

-- Remap space as a leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Source current file
keymap("n", "<Leader><CR>", ":source %<CR>", opts)

--
-- Easier movement between vim windows
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

--
-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

--
-- Resizing: Use Ctrl + arrows to resize windows
keymap("n", "<C-Up>", ":resize -5<cr>", opts)
keymap("n", "<C-Down>", ":resize +5<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<cr>", opts)

--
-- Vim-fugitive
keymap("n", "<leader>gs", ":G<cr>", opts) -- git status
-- resolve conflicts when merging branches (not used)
-- keymap("n", "<leader>gj", ":diffget //3<cr>", opts)
-- keymap("n", "<leader>gf", ":diffget //2<cr>", opts)

--
-- Project View (File Explorer)
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

--
-- Undotree
keymap("n", "<leader>u", ":UndotreeToggle<cr>", opts)

--
-- Very Useful Stuff
keymap("n", "Q", "", opts) -- disable Q coz useless
keymap("n", "<leader>q", ":Bdelete<cr>", opts) -- close current buffer
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

-- convert fileformat from dos/unix to unix (https://vim.fandom.com/wiki/File_format#Converting_the_current_file)
keymap("n", "<leader>wtu", ":update<cr> :e ++ff=dos<cr> :setlocal ff=unix<cr> :w<cr>", opts)
keymap("n", "<leader>cr", ":ColorizerReloadAllBuffers<cr>", opts) -- reload colorizer

--
-- Jumplist mutations: when you do 15j in normal mode and than C-o, it wouldn't
-- do 15k for you. With next remaps you modify your Jumplist (used by C-o and C-i)
-- to add break points every time you jump more than 5 lines up or down.
-- Maybe I'll rewrite this in lua someday
vim.cmd [[nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k']]
vim.cmd [[nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j']]

-- PackerSync remap
keymap("n", "<leader>s", ":PackerSync<cr>", opts)

-- Telescope keybindings
-- with next command search for the word under the cursor
keymap(
    "n",
    "<leader>pw",
    ':lua require("telescope.builtin").grep_string { search = vim.fn.expand("<cword>") }<CR>',
    opts
)
keymap("n", "<leader>ps", ":lua require('telescope.builtin').live_grep()<CR>", opts)
keymap("n", "<C-f>", ":lua require('trimclain.telescope').curr_buf_search()<CR>", opts)
keymap("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<CR>", opts)

keymap("n", "<leader>gh", ":lua require('telescope.builtin').help_tags()<CR>", opts)
keymap("n", "<leader>gk", ":lua require('telescope.builtin').keymaps()<CR>", opts)
keymap("n", "<leader>gl", ":lua require('telescope.builtin').git_commits()<CR>", opts)
keymap("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>", opts)

keymap("n", "<leader>pf", ":Telescope find_files<cr>", opts)
keymap("n", "<leader>phf", ":Telescope find_files hidden=true<cr>", opts)
keymap("n", "<leader>pb", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>of", ":Telescope oldfiles<cr>", opts)

keymap("n", "<leader>vrc", ":Telescope git_files cwd=~/.dotfiles<cr>", opts)
keymap("n", "<leader>f;", ":Telescope commands<cr>", opts)

-- Esc is too far and I don't like <C-[>, make <C-c> work as <Esc> in every mode
keymap("", "<C-c>", "<Esc>", opts) -- normal, visual, select, operator-pending modes
keymap("l", "<C-c>", "<Esc>", opts) -- insert, command-line, lang-arg modes
keymap("i", "<C-c>", "<Esc>", opts) -- insert mode again, coz doesn't work above

--
-- Run a file
keymap("n", "<C-b>", ":w <bar> :! ./%<cr>", opts)

--
-- " QuickFixList Stuff (from Prime, rewritten in lua) - local ones not in use
keymap("n", "<leader><leader>j", ":cnext<CR>zz", opts)
keymap("n", "<leader><leader>k", ":cprev<CR>zz", opts)
-- keymap("n", "<leader>j", ":lnext<CR>zz", opts)
-- keymap("n", "<leader>k", ":lprev<CR>zz", opts)
keymap("n", "<C-q>", "<cmd>lua require('trimclain.keymaps').ToggleQFList(1)<CR>", opts)
-- keymap("n", "<leader>q", "<cmd>lua require('trimclain.keymaps').ToggleQFList(0)<CR>", opts)

--
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
