local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local join_paths = require("trimclain.utils").join_paths

local setup = {
    plugins = {
        marks = false, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
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
        ["<leader>"] = "Space",
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
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
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
    ["<cr>"] = { "<cmd>source %<cr>", "Source Buffer" },
    a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add Harpoon Mark" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    d = { '"_d', "Delete to black hole" },
    e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    q = { "<cmd>Bdelete<cr>", "Close Buffer" },
    u = { "<cmd>UndotreeToggle<cr>", "UndoTree" },
    Y = { 'gg"+yG', "Yank Whole File" },
    w = { "<cmd>w<cr>", "Save File" },

    ["<leader>"] = {
        name = "Lab",
        ["1"] = { "<cmd>Lab code run<cr>", "Code run" },
        ["2"] = { "<cmd>Lab code stop<cr>", "Code stop" },
        ["3"] = { "<cmd>Lab code panel<cr>", "Code panel" },
    },

    c = {
        name = "Colorizer",
        r = { "<cmd>ColorizerReloadAllBuffers<cr>", "Reload" },
    },

    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    f = {
        name = "Find",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        d = { "<cmd>Telescope git_files cwd=" .. join_paths(os.getenv "HOME", ".dotfiles") .. "<cr>", "Dotfiles" },
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find Files" },
        s = { "<cmd>Telescope live_grep<cr>", "Find String" },
        w = { "<cmd>Telescope grep_string<cr>", "Find Word" },
        h = { "<cmd>Telescope help_tags<cr>", "Help" },
        H = { "<cmd>Telescope highlights<cr>", "Highlights" },
        l = { "<cmd>Telescope resume<cr>", "Last Search" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        -- n = { "<cmd>Telescope notify<cr>", "Notifications" }, -- TODO: to make it work
        n = { "<cmd>Notifications<cr>", "Notifications" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Telescope Commands" },
    },

    g = {
        name = "Git",
        b = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", "Branches" },
        l = { "<cmd>lua require('telescope.builtin').git_commits()<cr>", "Commits" },
        s = { "<cmd>Neogit<cr>", "Status" },
    },

    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        F = { "<cmd>FormattingToggle<cr>", "Toggle Autoformat" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        m = { "<cmd>Mason<cr>", "Mason" },
        j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
        k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        R = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    },

    m = {
        name = "Make",
        x = { "<cmd>w <cr> <cmd>!chmod +x %<cr>", "Executable" },
    },

    n = {
        name = "Neogen",
        g = { "<cmd>lua require('neogen').generate()<cr>", "Generate annotations for current function" },
        c = { "<cmd>lua require('neogen').generate({type = 'class'})<cr>", "Generate annotations for current class" },
        t = { "<cmd>lua require('neogen').generate({type = 'type'})<cr>", "Generate annotations for current type" },
        f = { "<cmd>lua require('neogen').generate({type = 'file'})<cr>", "Generate annotations for current file" },
    },

    r = {
        name = "Replace/Refactor",
        r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
        ["."] = { ":%s/\\<<c-r><c-w>\\>/", "Replace Word Vim Style" },

        b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract Block" },
        B = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>", "Extract Block To File" },
        i = {
            "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
            "Extract Inline Variable under cursor",
        },
    },

    s = {
        name = "Snippets",
        s = {
            "<cmd>source "
                .. join_paths(os.getenv "HOME", ".config", "nvim", "lua", "trimclain", "plugins", "luasnip.lua")
                .. "<cr>",
            "Source luasnip.lua",
        },
    },

    t = {
        name = "Terminal",
        p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
        h = { "<cmd>lua _HTOP_TOGGLE()<cr>", "HTOP" },
        b = { "<cmd>lua _BTOP_TOGGLE()<cr>", "BTOP" },
    },

    v = {
        name = "Vim",
        r = { "<cmd>lua require('trimclain.utils').restart()<cr>", "Restart" },
        -- convert fileformat from dos/unix to unix (https://vim.fandom.com/wiki/File_format#Converting_the_current_file)
        u = { ":update<cr> :e ++ff=dos<cr> :setlocal ff=unix<cr> :w<cr>", "Change fileformat from dos to unix" },
    },

    o = {
        name = "Options",
        w = { '<cmd>lua require("trimclain.utils").toggle_option("wrap")<cr>', "Wrap" },
        r = { '<cmd>lua require("trimclain.utils").toggle_option("relativenumber")<cr>', "Relative" },
        l = { '<cmd>lua require("trimclain.utils").toggle_option("cursorline")<cr>', "Cursorline" },
        s = { '<cmd>lua require("trimclain.utils").toggle_option("spell")<cr>', "Spell" },
        t = { '<cmd>lua require("trimclain.utils").toggle_shiftwidth()<cr>', "Shiftwidth" },
    },
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
    r = {
        name = "Refactor",
        f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Function" },
        F = { "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract Function To File" },
        v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract Variable" },
        i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Extract Inline Variable" },
    },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
