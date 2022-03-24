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

require "trimclain.impatient" -- must load first to get that juicy speedup
require "trimclain.options"
require "trimclain.keymaps"
require "trimclain.plugins"
require "trimclain.catppuccin"
require "trimclain.colorscheme"
require "trimclain.lualine"
require "trimclain.indentline"
require "trimclain.cmp"
require "trimclain.lsp"
require "trimclain.telescope"
require "trimclain.treesitter"
require "trimclain.autopairs"
require "trimclain.comments"
require "trimclain.gitsigns"
require "trimclain.nvim-tree" -- not sure I like this (adds +15-20ms startup time)
require "trimclain.toggleterm"
-- require ("trimclain.netrw")
require "trimclain.colorizer"
require "trimclain.markdown-preview"
require "trimclain.bracey"
require "trimclain.autocmd"
