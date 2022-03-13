-- #############################################################################
-- LSP Setup
-- #############################################################################

-- nvim-autopairs part 1
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require'cmp'

-- nvim-autopairs part 2
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

