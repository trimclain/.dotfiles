local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        ["<leader>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = false, -- show help message on the command line when the popup is visible
    -- triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["<CR>"] = { "Source Buffer" },
    a = { "Add Harpoon Mark" },
    b = { "Buffers" },
    d = { "Delete, don't cut" },
    e = { "Explorer" },
    h = { "Left Buffer" },
    j = { "Bottom Buffer" },
    k = { "Top Buffer" },
    l = { "Right Buffer" },
    q = { "Close Buffer" },
    s = { "Packer Sync" },
    u = { "UndoTree" },
    Y = { "Yank Whole File" },

    ["<leader>"] = {
        name = "Lab",
        ["1"] = { "Code run" },
        ["2"] = { "Code stop" },
        ["3"] = { "Code panel" },
        j = { "Go to next quickfixlist location" },
        k = { "Go to previous quickfixlist location" },
    },

    c = {
        name = "Colorizer",
        r = { "Reload" },
    },

    f = {
        name = "File",
        f = { "Format the file" },
        t = { "Toggle Formatting" },
        [";"] = { "Show Telescope Commands" },
    },

    g = {
        name = "Get",
        b = { "Branches" },
        h = { "Help" },
        k = { "Keymaps" },
        l = { "Commits" },
        s = { "Git Status" },
    },

    m = {
        name = "Make",
        x = "Executable",
    },

    r = {
        name = "Do",
        n = { "Rename" },
    },

    p = {
        name = "Project",
        w = { "Word" },
        s = { "Search" },
        f = { "Files" },
        h = { "Hidden Files" },
        y = { "Open Python3 Console" },
    },

    v = {
        name = "Vim",
        r = {
            name = "Run Commands",
            c = { "Open .dotfiles in Telescope" },
        },
    },

    w = {
        name = "Windows",
        t = {
            name = "To",
            u = { "Change fileformat from dos to unix" },
        },
    },

    o = {
        name = "Open",
        f = { "Old Files" },
    },

    -- o = {
    --     name = "Options",
    --     c = { "<cmd>lua vim.g.cmp_active=false<cr>", "Completion off" },
    --     C = { "<cmd>lua vim.g.cmp_active=true<cr>", "Completion on" },
    --     w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
    --     r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
    --     l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
    --     s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
    --     t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
    -- },
}

local vopts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
    d = { "Delete, don't cut" },
    --     ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', "Comment" },
    --     s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
    --     -- z = { "<cmd>TZNarrow<cr>", "Narrow" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
