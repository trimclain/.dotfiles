return {
    {
        -- PERF: this takes 18-20 ms on startup even though it's lazy loaded... Why??
        "L3MON4D3/LuaSnip",
        -- cond = false,
        version = "v2.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            update_events = { "TextChanged", "TextChangedI" },
            delete_check_events = "TextChanged",
        },
        config = function(_, opts)
            local luasnip = require("luasnip")
            luasnip.setup(opts)
            luasnip.filetype_extend("javascript", { "javascriptreact", "html" }) -- add jsx and html snippets to js
            luasnip.filetype_extend("javascriptreact", { "javascript", "html" }) -- add js and html snippets to jsx
            luasnip.filetype_extend("typescriptreact", { "javascript", "html" }) -- add js and html snippets to tsx

            -- my own snippets
            require("luasnip.loaders.from_lua").lazy_load({
                paths = {
                    -- Load local snippets if present
                    -- vim.fn.getcwd() .. "/.snippets",
                    -- Global snippets
                    vim.fn.stdpath("config") .. "/snippets",
                },
            })
        end,
        keys = function()
            local luasnip = require("luasnip")
            return {
                {

                    "<c-k>",
                    function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end,
                    silent = true,
                    mode = { "i", "s" },
                },
                {
                    "<c-j>",
                    function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end,
                    silent = true,
                    mode = { "i", "s" },
                },
                {
                    "<c-h>",
                    function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(-1)
                        end
                    end,
                    mode = { "i", "s" },
                },
                {
                    "<c-l>",
                    function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end,
                    mode = { "i", "s" },
                },
            }
        end,
    },
}
