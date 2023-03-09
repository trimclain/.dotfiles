local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local mnls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mnls_status_ok then
    return
end

-- Sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- Sources: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        -- Formatters
        formatting.prettierd.with {
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
        formatting.beautysh,

        -- Linters
        diagnostics.flake8,
        diagnostics.shellcheck,
        diagnostics.eslint_d, -- Once spawned, the server will continue to run in the background.
                              -- This is normal and not related to null-ls.
                              -- You can stop it by running eslint_d stop from the command line.

    },
}

mason_null_ls.setup {
    -- A list of sources to install if they're not already installed.
    -- This setting has no relation with the `automatic_installation` setting.
    -- ensure_installed = tools,
    ensure_installed = nil,
    -- Run `require("null-ls").setup`.
    -- Will automatically install masons tools based on selected sources in `null-ls`.
    -- Can also be an exclusion list.
    -- Example: `automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }`
    -- automatic_installation = false,
    automatic_installation = true,

	-- Whether sources that are installed in mason should be automatically set up in null-ls.
	-- Removes the need to set up null-ls manually.
	-- Can either be:
	-- 	- false: Null-ls is not automatically registered.
	-- 	- true: Null-ls is automatically registered.
	-- 	- { types = { SOURCE_NAME = {TYPES} } }. Allows overriding default configuration.
	-- 	Ex: { types = { eslint_d = {'formatting'} } }
	automatic_setup = false,
}
