-- Completion Enginge
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    vim.notify "CMP not found"
    return
end

-- Snippets
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    vim.notify "Luasnip not found"
    return
end

-- Load vscode snippets
require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
-- local kind_icons = {
--     Text = "",
--     Method = "m",
--     Function = "",
--     Constructor = "",
--     Field = "",
--     Variable = "",
--     Class = "",
--     Interface = "",
--     Module = "",
--     Property = "",
--     Unit = "",
--     Value = "",
--     Enum = "",
--     Keyword = "",
--     Snippet = "",
--     Color = "",
--     File = "",
--     Reference = "",
--     Folder = "",
--     EnumMember = "",
--     Constant = "",
--     Struct = "",
--     Event = "",
--     Operator = "",
--     TypeParameter = "",
-- }

local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = {
        -- Same as <C-n> and <C-p>
        -- ["<C-k>"] = cmp.mapping.select_prev_item(),
        -- ["<C-j>"] = cmp.mapping.select_next_item(),
        --
        -- To scroll through a big popup windows
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-2), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(2), { "i", "c" }),
        --
        -- Show autocomplete options without typing anything
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        -- Not sure what this does
        -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        --
        -- Close autocompletion popup window
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = true },
        -- Make SuperTab
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- I have my own keybinds for this in luasnip config
                -- elseif luasnip.expandable() then
                --     luasnip.expand()
                -- elseif luasnip.expand_or_jumpable() then
                --     luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
                -- I have my own keybinds for this in luasnip config
                -- elseif luasnip.jumpable(-1) then
                --     luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[lua]",
                luasnip = "[snip]",
                buffer = "[buf]",
                path = "[path]",
                cmdline = "[cmd]",
                spell = "[spell]",
            })[entry.source.name]
            return vim_item
        end,
    },

    sources = cmp.config.sources({
        -- the order sets priority
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        {
            name = "spell",
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
            },
        },
    }, {
        { name = "buffer", keyword_length = 1 }, -- keyword_length specifies word length to start suggestions
    }),

    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },

    experimental = {
        ghost_text = false,
        native_menu = false,
    },
}

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--     }, {
--         { name = 'buffer' },
--     })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline", keyword_length = 2 }, -- otherwise too much info
    }),
})
