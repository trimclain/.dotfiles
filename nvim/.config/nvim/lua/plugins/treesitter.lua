return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                keys = {
                    {
                        "[c",
                        function()
                            require("treesitter-context").go_to_context()
                        end,
                        desc = "Jump to context (upwards)",
                    },
                },
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
            highlight = {
                enable = true,
                -- disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    -- return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            indent = {
                enable = true,
                disable = { "julia" }, -- sadly broken right now
            },
            -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ensure_installed = {
                "bash",
                "c",
                "css",
                -- "dockerfile",
                -- "graphql",
                "html",
                "java",
                "javascript",
                "json",
                "jsonc",
                "julia",
                -- "kotlin",
                "latex",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "query", -- treesitter query
                "rasi", -- rofi config syntax highlighting
                "regex",
                -- "rust",
                "scss",
                "sql",
                -- "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
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
