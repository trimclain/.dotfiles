return {
    -- auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true, -- work with treesitter
            -- ts_config = {
            --     lua = {'string'},-- it will not add a pair on that treesitter node
            --     javascript = {'template_string'},
            --     java = false,-- don't check treesitter on java
            -- },
            disable_filetype = { "TelescopePrompt", "spectre_panel", "vim", "text", "markdown" },
            disable_in_macro = true, -- disable when recording or executing a macro
            -- I use this instead of surround for now
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'", "`" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            npairs.setup(opts)

            -- Create a rule to add spaces between parentheses
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            npairs.add_rules({
                Rule(" ", " "):with_pair(function(options)
                    local pair = options.line:sub(options.col - 1, options.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),
            })
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(options)
                            return options.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                })
            end

            -- A rule for arrow key on javascript
            Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
                :use_regex(true)
                :set_end_pair_length(2)
        end,
    },

    -- close tags using treesitter
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter",
        event = "InsertEnter",
        config = true,
    },
}
