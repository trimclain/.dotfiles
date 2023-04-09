return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require("treesitter-context").setup({
                        max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
                    })
                end,
            },
        },
        -- keys = {
        --   { "<c-space>", desc = "Increment selection" },
        --   { "<bs>", desc = "Decrement selection", mode = "x" },
        -- },
        ---@type TSConfig
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false }, -- nvim-ts-context-commentstring
            autotag = { enable = true }, -- nvim-ts-autotag
            -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ensure_installed = {
                "bash",
                "css",
                "dockerfile",
                "graphql",
                "html",
                "java",
                "javascript",
                "json",
                -- "julia",
                "kotlin",
                "latex",
                "lua",
                "luadoc",
                "luap",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "query", -- ?
                "rasi", -- rofi config syntax highlighting
                "regex",
                "scss",
                "sql",
                "tsx",
                "typescript",
                "vim",
                "vue",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
