local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node

return {
    -- lazy-lock
    s("ll", {
        t("chore(nvim): update lazy-lock"),
    }),
    -- config update
    s("cu", {
        t("chore"),
        c(1, {
            sn(nil, {
                t("("),
                i(1, "scope"),
                t(")"),
            }),
            t(""),
        }),
        t(": update config"),
    }),
    -- docs update
    s("du", {
        t("docs: update README"),
    }),
}
