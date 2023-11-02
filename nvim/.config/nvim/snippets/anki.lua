local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node

return {
    -- MathJax inline equiation
    s("$", {
        t("\\("),
        i(1, ""),
        t("\\)"),
    }),
    -- MathJax block equiation
    s("[", {
        t("\\["),
        i(1, ""),
        t("\\]"),
    }),
    -- Mathbb
    s("b", {
        t("\\mathbb{"),
        i(1, ""),
        t("}"),
    }),
    -- Mathcal
    s("c", {
        t("\\mathcal{"),
        i(1, ""),
        t("}"),
    }),
    -- Epsilon
    s("e", {
        t("\\varepsilon"),
    }),
}
