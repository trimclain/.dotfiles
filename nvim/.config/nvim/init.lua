--#############################################################################
--        ______ ___    __ __   ___    ____  __     __     __  __   __
--       /_  __//   \  / //  \ /   |  / __/ / /    /  |   / / /  \ / /
--        / /  /   _/ / // /\\/ /| | / /   / /    /   |  / / / /\\/ /
--       / /  / /\ \ / // / \/_/ | |/ /__ / /___ / _  | / / / / \/ /
--      /_/  /_/ \_\/_//_/       |_|\___//_____//_/ \_|/_/ /_/  /_/
--
--
--       Arthur McLain (trimclain)
--       mclain.it@gmail.com
--       https://github.com/trimclain
--
--#############################################################################

require "trimclain.impatient"
require "trimclain.disable-builtins"

require "trimclain.options"
require "trimclain.keymaps"

require "trimclain.plugins"

require "trimclain.colorscheme"

-- waiting for the fix https://github.com/nvim-lualine/lualine.nvim/issues/773
require "trimclain.lualine"
require "trimclain.indentline"
require "trimclain.bufferline"

require "trimclain.hop"
require "trimclain.neoscroll"

require "trimclain.cmp"

-- require "trimclain.lsp-inlayhints"
require "trimclain.lsp"
require "trimclain.luasnip"
require "trimclain.telescope"
require "trimclain.harpoon"
require "trimclain.treesitter"
require "trimclain.fidget"
require "trimclain.whichkey"

require "trimclain.gps"
-- require "trimclain.navic" -- waiting for color support
-- waiting for the fix https://github.com/nvim-lualine/lualine.nvim/issues/773
require "trimclain.winbar"

require "trimclain.autopairs"
require "trimclain.autotags"
require "trimclain.comments"
require "trimclain.neogen"
-- waiting for the fix https://github.com/nvim-lualine/lualine.nvim/issues/773
require "trimclain.todo-comments"
require "trimclain.gitsigns"
require "trimclain.nvim-tree"
require "trimclain.toggleterm"
require "trimclain.notify"
require "trimclain.colorizer"
require "trimclain.colorpicker"

require "trimclain.spectre"
require "trimclain.numb"
require "trimclain.jaq"
require "trimclain.lab"
require "trimclain.markdown-preview"
require "trimclain.bracey"

require "trimclain.autocmd"
