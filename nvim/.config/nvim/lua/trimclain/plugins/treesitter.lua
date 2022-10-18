local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "python",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "lua",
        "bash",
        "vim",
        "yaml",
        "markdown",
        "make",
        "json",
        "rasi", -- rofi config syntax highlighting
        "latex",
        "julia",
        "java",
        "kotlin",
        "dockerfile",
        "graphql",
        "sql",
    },
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true, -- work with nvim-autopairs
    },

    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "html" }, -- list of language that will be disabled (html buggy for now)

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Instead of true it can also be a list of languages
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        additional_vim_regex_highlighting = false,
    },
    -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
    indent = {
        enable = true,
        disable = { "yaml", "python" },
    },
    -- For ts-comments
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            -- as example the default config for js
            javascript = {
                __default = "// %s",
                jsx_element = "{/* %s */}",
                jsx_fragment = "{/* %s */}",
                jsx_attribute = "// %s",
                comment = "// %s",
            },
        },
    },
    -- incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --         init_selection = "gnn",
    --         node_incremental = "grn",
    --         scope_incremental = "grc",
    --         node_decremental = "grm",
    --     },
    -- },
    -- textobjects = {
    --     select = {
    --         enable = true,
    --         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
    --         keymaps = {
    --             -- You can use the capture groups defined in textobjects.scm
    --             ["af"] = "@function.outer",
    --             ["if"] = "@function.inner",
    --             ["ac"] = "@class.outer",
    --             ["ic"] = "@class.inner",
    --         },
    --     },
    --     move = {
    --         enable = true,
    --         set_jumps = true, -- whether to set jumps in the jumplist
    --         goto_next_start = {
    --             ["]m"] = "@function.outer",
    --             ["]]"] = "@class.outer",
    --         },
    --         goto_next_end = {
    --             ["]M"] = "@function.outer",
    --             ["]["] = "@class.outer",
    --         },
    --         goto_previous_start = {
    --             ["[m"] = "@function.outer",
    --             ["[["] = "@class.outer",
    --         },
    --         goto_previous_end = {
    --             ["[M"] = "@function.outer",
    --             ["[]"] = "@class.outer",
    --         },
    --     },
    -- },
}
