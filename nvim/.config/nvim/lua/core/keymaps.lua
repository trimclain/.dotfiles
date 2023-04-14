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
-- How to change split directions
-- vertical to horizontal: <c-w>K
-- horizontal to vertical: <c-w>H

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
keymap("n", "J", "mzJ`z", opts) -- keep it centered when joining lines
keymap("i", ",", ",<c-g>u", opts) -- set a break point for undo after ,
keymap("i", ".", ".<c-g>u", opts) -- after .
keymap("i", "!", "!<c-g>u", opts) -- after !
keymap("i", "?", "?<c-g>u", opts) -- after ?
keymap("v", "K", ":m '<-2<cr>gv=gv", opts) -- move higlighted lines up a line
keymap("v", "J", ":m '>+1<cr>gv=gv", opts) -- and down a line
keymap("v", "<", "<gv", opts) -- stay in indent mode
keymap("v", ">", ">gv", opts) -- stay in indent mode
keymap("v", "<S-h>", "<gv", opts) -- feels natural
keymap("v", "<S-l>", ">gv", opts) -- feels natural
keymap("v", "y", "myy`y", opts) -- Maintain the cursor position
keymap("v", "Y", "myy`y", opts) -- when yanking a visual selection
keymap("v", "p", '"_dP', opts) -- when replacing a higlighted text, don't yank it
keymap("n", "<leader>d", '"_d', add_desc("Delete to black hole"))
keymap("i", "<C-r>", "<C-r>+", opts) -- paste from clipboard in insert mode
keymap("c", "<C-r>", "<C-r>+", opts) -- paste from clipboard in command mode
keymap("n", "<leader>r.", ":%s/\\<<c-r><c-w>\\>/", add_desc("Replace Word Vim Style"))
keymap("n", "<leader>Y", 'gg"+yG', add_desc("Yank Whole File"))
keymap("n", "<leader>w", "<cmd>w<cr>", add_desc("Save File"))

-- Store relative line number jumps in the jumplist if they exceed a threshold.
keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- convert fileformat from dos/unix to unix (https://vim.fandom.com/wiki/File_format#Converting_the_current_file)
keymap(
    "n",
    "<leader>vu",
    ":update<cr> :e ++ff=dos<cr> :setlocal ff=unix<cr> :w<cr>",
    add_desc("Change fileformat from dos to unix")
)

-- Open tmux-sessionizer
keymap("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- stylua: ignore start
keymap("n", "gx", function() require("core.util").open_url() end, add_desc("Open URL under cursor"))
keymap("n", "<leader>re", function() require("core.util").empty_registers() end, add_desc("Empty registers"))
keymap("n", "<leader>mx", function() require("core.util").toggle_executable() end, add_desc("Make Current File Executable"))

keymap("n", "<leader>ow", function() require("core.util").toggle_option("wrap") end, add_desc("Toggle Current Buffer Line Wrap"))
keymap("n", "<leader>on", function() require("core.util").toggle_option("number") end, add_desc("Toggle Current Buffer Line Numbers"))
keymap("n", "<leader>or", function() require("core.util").toggle_option("relativenumber") end, add_desc("Toggle Current Buffer Relative Numbers"))
keymap("n", "<leader>ol", function() require("core.util").toggle_option("cursorline") end, add_desc("Toggle Current Buffer Cursorline"))
keymap("n", "<leader>os", function() require("core.util").toggle_option("spell") end, add_desc("Toggle Current Buffer Spell"))
keymap("n", "<leader>ot", function() require("core.util").toggle_shiftwidth() end, add_desc("Toggle Shiftwidth"))
-- stylua: ignore end

-------------------------------------------------------------------------------

-- Lazy
keymap("n", "<leader>pl", "<cmd>Lazy home<cr>", add_desc("Open Lazy"))
keymap("n", "<leader>ps", "<cmd>Lazy sync<cr>", add_desc("Lazy Sync"))
keymap("n", "<leader>pp", "<cmd>Lazy profile<cr>", add_desc("Lazy Profile"))

-- " QuickFixList Stuff
-- keymap("n", "<up>", ":cprev<CR>zz", opts)
-- keymap("n", "<down>", ":cnext<CR>zz", opts)
-- keymap("n", "<C-q>", "<cmd>lua require('core.utils').ToggleQFList()<CR>", opts)
