local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        formatting.prettier.with {
            extra_args = { "--tab-width=4" }, -- , "--jsx-single-quote", "--no-semi", "--single-quote",
            extra_filetypes = { "toml" },
        },
        formatting.black.with {
            extra_args = {
                "--fast", -- if --fast given, skip temporary sanity checks [default: --safe]
                -- "--skip-string-normalization", -- don't normalize string quotes (don't change single to double) or prefixes
            },
        },
        formatting.stylua,
        -- formatting.shfmt,

        diagnostics.flake8,
        -- diagnostics.shellcheck,
    },
}
