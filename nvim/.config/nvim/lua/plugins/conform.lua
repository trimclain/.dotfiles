-- Formatting
return {
    {
        "stevearc/conform.nvim",
        -- event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "LSP: [F]ormat buffer",
            },
            {
                "<leader>lc",
                function()
                    require("conform.health").show_window()
                end,
                mode = "n",
                desc = "LSP: [C]onform Info",
            },
        },
        opts = {
            -- notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if not CONFIG.lsp.format_on_save or vim.b[bufnr].disable_autoformat then
                    return
                end
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = "never"
                else
                    lsp_format_opt = "fallback"
                end
                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                sh = { "shfmt" }, -- beautysh
                go = { "gofumpt" },
                -- run multiple formatters sequentially
                python = { "isort", "autopep8" }, -- ruff
                -- use a sub-list to tell conform to run *until* a formatter is found

                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                vue = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                scss = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                jsonc = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                toml = { "prettierd", "prettier", stop_after_first = true },
                -- graphql = { { "prettierd", "prettier" } },
                -- svelte = { { "prettierd", "prettier" } },
                -- astro = { { "prettierd", "prettier" } },
            },
            formatters = {
                prettierd = {
                    prepend_args = { "--tab-width=4" }, -- "--jsx-single-quote", "--no-semi", "--single-quote",
                },
                -- shfmt = {
                --     -- The base args are { "-filename", "$FILENAME" } so the final args will be
                --     -- { "-i", "2", "-filename", "$FILENAME" }
                --     prepend_args = { "-i", "2" },
                -- }
            },
        },
        config = function(_, opts)
            require("conform").setup(opts)

            -- Use conform for gq.
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

            -- TODO: implement this
            -- SOMEDAY: make this a toggle (see core.util for old stuff)
            -- vim.api.nvim_create_user_command("FormatDisable", function()
            --     vim.b.disable_autoformat = true
            -- end, {
            --     desc = "Disable autoformat-on-save",
            --     bang = true,
            -- })
            -- vim.api.nvim_create_user_command("FormatEnable", function()
            --     vim.b.disable_autoformat = false
            -- end, {
            --     desc = "Re-enable autoformat-on-save",
            -- })
            --         vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
    },
}
