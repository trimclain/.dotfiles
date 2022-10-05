local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
    return
end

local servers = {
    "pyright",
    "html",
    "cssls",
    "cssmodules_ls",
    "emmet_ls",
    -- "tailwindcss",
    "tsserver",
    "jsonls",
    "sumneko_lua",
    "bashls",
    "vimls",
    "yamlls",
    "graphql",
    -- "julials",
    -- "ansiblels",
    "dockerls",
}

local settings = {
    ui = {
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "rounded", -- default: "none"

        icons = {
            -- The list icon to use for installed packages.
            package_installed = "◍",
            -- The list icon to use for packages that are installing, or queued for installation.
            package_pending = "◍",
            -- The list icon to use for packages that are not installed.
            package_uninstalled = "◍",
        },

        keymaps = {
            -- Keymap to expand a package
            toggle_package_expand = "<CR>",
            -- Keymap to install the package under the current cursor position
            install_package = "i",
            -- Keymap to reinstall/update the package under the current cursor position
            update_package = "u",
            -- Keymap to check for new version for the package under the current cursor position
            check_package_version = "c",
            -- Keymap to update all installed packages
            update_all_packages = "U",
            -- Keymap to check which installed packages are outdated
            check_outdated_packages = "C",
            -- Keymap to uninstall a package
            uninstall_package = "X",
            -- Keymap to cancel a package installation
            cancel_installation = "<C-c>",
            -- Keymap to apply language filter
            apply_language_filter = "<C-f>",
        },
    },

    -- The directory in which to install packages.
    -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },

    pip = {
        -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
        -- and is not recommended.
        --
        -- Example: { "--proxy", "https://proxyserver" }
        install_args = {},
    },

    -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
    -- debugging issues with package installations.
    log_level = vim.log.levels.INFO,

    -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
    -- packages that are requested to be installed will be put in a queue.
    max_concurrent_installers = 4,

    github = {
        -- The template URL to use when downloading assets from GitHub.
        -- The placeholders are the following (in order):
        -- 1. The repository (e.g. "rust-lang/rust-analyzer")
        -- 2. The release version (e.g. "v0.3.0")
        -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
}

mason.setup(settings)
mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

-- TODO: make this work
-- local lua_dev_status_ok, lua_dev = pcall(require, "lua-dev")
-- if not lua_dev_status_ok then
--     return
-- end
-- lua_dev.setup {
--     -- add any options here, or leave empty to use the default settings
--     library = {
--         enabled = true, -- when not enabled, lua-dev will not change any settings to the LSP server
--         -- these settings will be used for your Neovim config directory
--         runtime = true, -- runtime path
--         types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
--         plugins = true, -- installed opt or start plugins in packpath
--         -- you can also specify the list of plugins to make available as a workspace library
--         -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
--     },
--     setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
--     -- for your Neovim config directory, the config.library settings will be used as is
--     -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
--     -- for any other directory, config.library.enabled will be set to false
--     override = function(root_dir, options) end,
-- }

for _, server in pairs(servers) do
    local opts = {
        on_attach = require("trimclain.lsp.handlers").on_attach,
        capabilities = require("trimclain.lsp.handlers").capabilities,
    }

    local has_custom_opts, server_custom_opts = pcall(require, "trimclain.lsp.settings." .. server)
    if has_custom_opts then
        opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
    end

    -- if server == "sumneko_lua" then
    --     -- local sumneko_opts = require "trimclain.lsp.settings.sumneko_lua"
    --     -- opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    --     -- opts = vim.tbl_deep_extend("force", require("lua-dev").setup(), opts)
    --     lspconfig.sumneko_lua.setup(luadev)
    --     goto continue
    -- end

    lspconfig[server].setup(opts)
    -- ::continue::
end
