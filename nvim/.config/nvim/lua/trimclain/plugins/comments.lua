local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

comment.setup {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    -- ignore = nil,
    ignore = "^$", -- ignores empty lines
    ---LHS of toggle mappings in NORMAL mode

    toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
    },

    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
        ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
        extended = false,
    },
    ---Function to call before (un)comment
    --    Can be used to determine the commentstring value
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    -- pre_hook = function(ctx)
    --     -- For inlay hints
    --     local line_start = (ctx.srow or ctx.range.srow) - 1
    --     local line_end = ctx.erow or ctx.range.erow
    --     require("lsp-inlayhints.core").clear(0, line_start, line_end)

    --     require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    -- end,

    ---Function to call after (un)comment
    --    Can be used to alter any formatting / newlines / etc. after commenting
    post_hook = nil,
}

-- Manually set filetype comments
local comment_ft = require "Comment.ft"
comment_ft.set("lua", { "--%s", "--[[%s]]" })
comment_ft.set("markdown", { "[//]:%s", "<!--%s-->" })
