local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
    return
end

neogen.setup {
    enabled = true, --if you want to disable Neogen
    input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    languages = {}, -- configuration for default languages
    snippet_engine = "luasnip", -- use provided engine to place the annotations
    enable_placeholders = true, -- enables placeholders when inserting annotation

    -- Placeholders used during annotation expansion
    placeholders_text = {
        ["description"] = "[TODO:description]",
        ["tparam"] = "[TODO:tparam]",
        ["parameter"] = "[TODO:parameter]",
        ["return"] = "[TODO:return]",
        ["class"] = "[TODO:class]",
        ["throw"] = "[TODO:throw]",
        ["varargs"] = "[TODO:varargs]",
        ["type"] = "[TODO:type]",
        ["attribute"] = "[TODO:attribute]",
        ["args"] = "[TODO:args]",
        ["kwargs"] = "[TODO:kwargs]",
    },

    -- Placeholders highlights to use. If you don't want custom highlight, pass "None"
    placeholders_hl = "DiagnosticHint",
}
