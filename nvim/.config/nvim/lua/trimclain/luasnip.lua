local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    return
end

-- local types = require "luasnip.util.types"

luasnip.config.set_config {
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,
    -- This one is cool cause if you have dynamic snippets, it updates as you type!
    updateevents = "TextChanged,TextChangedI",

    -- Autosnippets:
    -- enable_autosnippets = true,

    -- Crazy highlights!!
    -- #vid3

    -- ext_opts = nil,
    -- ext_opts = {
    --     [types.choiceNode] = {
    --         active = {
    --             virt_text = { { " <- Current Choice", "NonTest" } },
    --         },
    --     },
    -- },
}

luasnip.filetype_extend("javascript", { "javascriptreact", "html" }) -- add jsx and html snippets to js
luasnip.filetype_extend("javascriptreact", { "javascript", "html" }) -- add js and html snippets to jsx
luasnip.filetype_extend("typescriptreact", { "javascript", "html" }) -- add js and html snippets to tsx

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)

-- vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")
