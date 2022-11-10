local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
    return
end

neogit.setup {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
    -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
    auto_refresh = true,
    disable_builtin_notifications = false,
    use_magit_keybindings = false,
    -- Change the default way of opening neogit
    kind = "replace", -- "replace", "tab", "split", "split_above", "vsplit", "floating"
    -- Change the default way of opening the commit popup
    commit_popup = {
        kind = "split",
    },
    -- Change the default way of opening popups
    popup = {
        kind = "split",
    },
    -- customize displayed signs
    signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
    },
    integrations = {
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
        -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        -- use {
        --   'TimUntersberger/neogit',
        --   requires = {
        --     'nvim-lua/plenary.nvim',
        --     'sindrets/diffview.nvim'
        --   }
        -- }
        --
        diffview = false,
    },
    -- Setting any section to `false` will make the section not render at all
    sections = {
        untracked = {
            folded = false,
        },
        unstaged = {
            folded = false,
        },
        staged = {
            folded = false,
        },
        stashes = {
            folded = true,
        },
        unpulled = {
            folded = true,
        },
        unmerged = {
            folded = false,
        },
        recent = {
            folded = true,
        },
    },
    -- override/add mappings
    mappings = {
        -- modify status buffer mappings
        status = {
            ["q"] = "Close",
            ["1"] = "Depth1",
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
            ["<tab>"] = "Toggle",
            ["="] = "Toggle", -- fugitive habbit
            ["x"] = "Discard",
            ["s"] = "Stage",
            -- ["a"] = "StageUnstaged",
            -- ["<c-s>"] = "StageAll",
            ["u"] = "Unstage",
            -- ["U"] = "UnstageStaged",
            -- ["d"] = "DiffAtFile",
            -- ["$"] = "CommandHistory",
            -- ["<c-r>"] = "RefreshBuffer",
            -- ["o"] = "GoToFile",
            -- ["<enter>"] = "Toggle",
            -- ["<c-v>"] = "VSplitOpen",
            -- ["<c-x>"] = "SplitOpen",
            -- ["<c-t>"] = "TabOpen",
            ["?"] = "HelpPopup",
            -- ["D"] = "DiffPopup",
            ["P"] = "PullPopup",
            -- ["r"] = "RebasePopup",
            ["p"] = "PushPopup",
            ["c"] = "CommitPopup",
            ["L"] = "LogPopup",
            -- ["Z"] = "StashPopup",
            -- ["b"] = "BranchPopup",
        },
    },
}
