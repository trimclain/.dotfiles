local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

-- Automatically install packer
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
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
return require('packer').startup(function(use)
    use "wbthomason/packer.nvim"            -- packer can manage itself
    use 'tpope/vim-commentary'              -- easy commenting, thanks tpope
    use 'tpope/vim-fugitive'                -- vim git integration, thanks tpope
    use 'windwp/nvim-autopairs'             -- automatically close brackets
    use 'nvim-lualine/lualine.nvim'         -- great status line in lua
    -- TODO: does it do anything?
    use 'google/vim-searchindex'            -- show the number of matches
    -- TODO: make it toggle
    use 'mbbill/undotree'                   -- see the undo history

    -- Colorschemes
    use {
        "catppuccin/nvim",
        as = "catppuccin"
    }

    -- LSP
    -- use 'neovim/nvim-lspconfig'            -- LSP configurations
    -- use 'hrsh7th/nvim-cmp'                 -- LSP Autocomplete Engine
    -- use 'hrsh7th/cmp-buffer'               -- autocomplete from buffer
    -- use 'hrsh7th/cmp-path'                 -- autocomplete path to files
    -- use 'hrsh7th/cmp-nvim-lsp'             -- get autoimport on complete and more
    -- use 'L3MON4D3/LuaSnip'                 -- snippets engine
    -- use 'rafamadriz/friendly-snippets'     -- get vscode-like snippets
    -- use 'onsails/lspkind-nvim'             -- add vscode-like pictograms to LSP
    -- use 'williamboman/nvim-lsp-installer'  -- add LspInstall <language>

    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'

    -- TODO: how to write this in packer?
    -- To preview HTML, CSS and JS files in browser
    -- use 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
    -- To preview markdown files in browser
    -- use 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    -- TODO: norcali's plugin is faster
    -- use 'ap/vim-css-color'                  -- preview colors in vim
    -- TODO: Treesitter
    -- TODO: 'tpope/vim-surround'               " easy surrounding, thanks tpope

    use 'tweekmonster/startuptime.vim'      -- check the startuptime of plugins

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
