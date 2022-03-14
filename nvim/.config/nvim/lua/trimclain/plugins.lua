local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

-- Automatically install packer
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    print "Installing packer, close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
-- packer.init {
--     display = {
--         open_fn = function()
--             return require("packer.util").float { border = "rounded" }
--         end,
--     },
-- }

-- Install your plugins here
return packer.startup(function(use)
    use "wbthomason/packer.nvim"            -- packer can manage itself
    use "numToStr/Comment.nvim"             -- easy commenting written in lua
    use "tpope/vim-fugitive"                -- vim git integration, thanks tpope
    use "windwp/nvim-autopairs"             -- automatically close brackets
    use "nvim-lualine/lualine.nvim"         -- great status line in lua
    -- TODO: does it do anything?
    use "google/vim-searchindex"            -- show the number of matches
    -- TODO: make it toggle
    use "mbbill/undotree"                   -- see the undo history
    use "norcalli/nvim-colorizer.lua"       -- preview colors in neovim

    -- Colorschemes
    use {
        "catppuccin/nvim",
        as = "catppuccin"
    }

    -- CMP plugins
    use "hrsh7th/nvim-cmp"                  -- The completion plugin
    use "hrsh7th/cmp-buffer"                -- buffer completions
    use "hrsh7th/cmp-path"                  -- path completions
    use "hrsh7th/cmp-cmdline"               -- cmdline completions
    use "saadparwaiz1/cmp_luasnip"          -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"              -- get the LSP completion
    use "hrsh7th/cmp-nvim-lua"              -- get the LSP for lua in nvim config

    -- Snippets
    use "L3MON4D3/LuaSnip"                  -- snippet engine
    use "rafamadriz/friendly-snippets"      -- some vscode snippets to use

    -- LSP
    use "neovim/nvim-lspconfig"             -- LSP configurations
    use "williamboman/nvim-lsp-installer"   -- add LspInstall <language>

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "nvim-telescope/telescope-fzy-native.nvim"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    -- Useful tools
    -- To preview markdown files in browser
    use {
        "iamcco/markdown-preview.nvim",
        run = "npm install --global yarn && cd app && yarn install",
        ft = { "markdown" },
        cmd = "MarkdownPreview"
    }
    -- To preview HTML, CSS and JS in browser
    use {
        "turbio/bracey.vim",
        run = "npm install --prefix server",
        cmd = "Bracey"
    }

    -- TODO: do I need this?
    -- "tpope/vim-surround"               " easy surrounding, thanks tpope

    use "tweekmonster/startuptime.vim"      -- check the startuptime of plugins

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
