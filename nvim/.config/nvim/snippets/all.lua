-----------------------------------------------------------------------------------------------------------
-- My Snippets for LuaSnip
-- Documentation: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Loading from lua: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
-----------------------------------------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node

return {
	s("trig", t("loaded!")),

    -- -- config update
    -- s("cu", {
    --     t("chore"),
    --     c(1, {
    --         sn(nil, {
    --             t("("),
    --             i(1, "scope"),
    --             t(")"),
    --         }),
    --         t(""),
    --     }),
    --     t(": update config"),
    -- }),
}
