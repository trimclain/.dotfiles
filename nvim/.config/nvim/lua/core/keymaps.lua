local Util = require("core.util")

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

--- Extend opts by adding a description, so the keymap appears in which-key
---@param desc string
---@return table
local add_desc = function(desc)
    return vim.tbl_extend("error", opts, { desc = desc })
end

-- Esc is too far and I don't like <C-[>, make <C-c> work as <Esc> in every mode
keymap("", "<C-c>", "<Esc>", opts) -- normal, visual, select, operator-pending modes
keymap("l", "<C-c>", "<Esc>", opts) -- insert, command-line, lang-arg modes
keymap("i", "<C-c>", "<Esc>", opts) -- insert mode again, coz doesn't work above

-- INFO:
-- How to modify macros:
-- paste from register: "ap
-- edit
-- yank back to the register: "ayy

-- INFO:
-- How to change split directions:
-- vertical to horizontal: <c-w>K
-- horizontal to vertical: <c-w>H

-- INFO:
-- How to check where was the keymap defined:
-- map <keymap> for Normal, Visual, Select, Operator-pending modes
-- map! <keymap> for Insert and Command-line modes

--
-- Easier movement between buffers (I'm fine with arrows and <C-w>jk for now -> more keys for whichkey)
-- keymap("n", "<left>", "<C-w>h", opts)
-- keymap("n", "<right>", "<C-w>l", opts)
-- keymap("n", "<leader>j", "<C-w>j", opts)
-- keymap("n", "<leader>k", "<C-w>k", opts)

--
-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- TODO: switch to navigate tabs
-- -- Tab navigation.
-- vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab page' })
-- vim.keymap.set('n', '<leader>tn', '<cmd>tab split<cr>', { desc = 'New tab page' })
-- vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = 'Close other tab pages' })

--
-- Resizing: Use Ctrl + arrows to resize buffers
keymap("n", "<C-Up>", ":resize -5<cr>", opts)
keymap("n", "<C-Down>", ":resize +5<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<cr>", opts)

--
-- Very Useful Stuff
keymap("n", "<leader><cr>", "<cmd>source %<cr>", add_desc("Source Buffer"))
keymap("n", "gp", "`[v`]", add_desc("Select recently pasted text"))
keymap("n", "Q", "<cmd>qa<cr>", opts) -- remap Q to :qa
keymap("n", "n", "nzzzv", opts) -- keep it centered when searching forward
keymap("n", "N", "Nzzzv", opts) -- and backwards

-- if not CONFIG.ui.neoscroll then
--     keymap("n", "<C-u>", "<C-u>zz", opts) -- keep it centered when scrolling up
--     keymap("n", "<C-d>", "<C-d>zz", opts) -- and down
-- end

keymap("n", "J", "mzJ`z", opts) -- keep it centered when joining lines
keymap("i", ",", ",<c-g>u", opts) -- set a break point for undo after ,
keymap("i", ".", ".<c-g>u", opts) -- after .
keymap("i", "!", "!<c-g>u", opts) -- after !
keymap("i", "?", "?<c-g>u", opts) -- after ?
keymap("v", "K", ":m '<-2<cr>gv=gv", opts) -- move higlighted lines up a line
keymap("v", "J", ":m '>+1<cr>gv=gv", opts) -- and down a line
keymap("v", "<", "<gv", opts) -- stay in
keymap("v", ">", ">gv", opts) -- indent mode
keymap("v", "<S-h>", "<gv", opts) -- feels
keymap("v", "<S-l>", ">gv", opts) -- natural
keymap("v", "y", "myy`y", opts) -- maintain the cursor position
keymap("v", "Y", "myy`y", opts) -- when yanking a visual selection
keymap("v", "p", '"_dP', opts) -- when replacing a higlighted text, don't yank it
keymap("n", "<leader>d", '"_d', add_desc("Delete to blackhole"))
keymap("i", "<C-r>", "<C-r>+", opts) -- paste from clipboard in insert mode
keymap("c", "<C-r>", "<C-r>+", opts) -- paste from clipboard in command mode
keymap("n", "M", "<cmd>Man<cr>", opts) -- open manual entry for word under cursor
keymap("n", "<leader>r.", ":%s/\\<<c-r><c-w>\\>/", add_desc("Replace Word Vim Style"))
keymap("n", "<leader>Y", 'gg"+yG', add_desc("Yank Whole File"))
keymap("n", "<leader>w", "<cmd>w<cr>", add_desc("Save File"))

-- Store relative line number jumps in the jumplist if they exceed a threshold.
keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- Open tmux-sessionizer
keymap("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- stylua: ignore start
keymap("n", "gx", function() Util.open_url() end, add_desc("Open URL under cursor"))
keymap("n", "gX", function() Util.open_github_url() end, add_desc("Open Github URL under cursor"))
keymap("n", "<leader>mx", function() Util.toggle_executable() end, add_desc("Make Current File Executable"))

-- Toggles
keymap("n", "<leader>ow", function() Util.toggle_option("wrap") end, add_desc("Toggle Current Buffer Line Wrap"))
keymap("n", "<leader>on", function() Util.toggle_option("number") end, add_desc("Toggle Current Buffer Line Numbers"))
keymap("n", "<leader>or", function() Util.toggle_option("relativenumber") end, add_desc("Toggle Current Buffer Relative Numbers"))
keymap("n", "<leader>ol", function() Util.toggle_option("cursorline") end, add_desc("Toggle Current Buffer Cursorline"))
keymap("n", "<leader>os", function() Util.toggle_option("spell") end, add_desc("Toggle Current Buffer Spell"))
keymap("n", "<leader>ot", function() Util.toggle_shiftwidth() end, add_desc("Toggle Shiftwidth"))
keymap("n", "<leader>od", function() Util.toggle_diagnostics() end, add_desc("Toggle LSP Diagnostics"))

if CONFIG.ui.illuminate then
    keymap("n", "<leader>oi", function() require("illuminate").toggle() end, add_desc("Toggle Vim Illuminate"))
end

keymap("n", "<leader>fp", function() Util.open_project() end, add_desc("Open Project"))
-- stylua: ignore end

-------------------------------------------------------------------------------

-- Lazy
keymap("n", "<leader>pl", "<cmd>Lazy home<cr>", add_desc("Open Lazy"))
keymap("n", "<leader>ps", "<cmd>Lazy sync<cr>", add_desc("Lazy Sync"))
keymap("n", "<leader>pp", "<cmd>Lazy profile<cr>", add_desc("Lazy Profile"))
keymap("n", "<leader>pr", "<cmd>Lazy restore<cr>", add_desc("Lazy Restore using lazy-lock.json"))

-- QuickFixList
keymap("n", "[q", "<cmd>cprev<cr>zz", add_desc("Previous item in QuickFixList"))
keymap("n", "]q", "<cmd>cnext<cr>zz", add_desc("Next item in QuickFixList"))
keymap("n", "<C-q>", Util.toggle_quickfix, add_desc("Toggle QuickFixList"))

-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
-- convert fileformat from dos/unix to unix (https://vim.fandom.com/wiki/File_format#Converting_the_current_file)
vim.api.nvim_create_user_command(
    "ConvertDos2Unix",
    ":update<cr> :e ++ff=dos<cr> :setlocal ff=unix<cr> :w<cr>",
    { desc = "Change fileformat from dos to unix" }
)

-- enable building with color
vim.api.nvim_create_user_command("BuildWithColor", function()
    keymap("n", "<C-b>", function()
        require("builder").build({ color = true })
    end)
end, { desc = "Remap <C-b> to build with color" })

-- clear registers in vim
vim.api.nvim_create_user_command("EmptyRegisters", function()
    Util.empty_registers()
end, { desc = "Empty :registers" })
