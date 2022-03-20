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
    print 'Installing packer, close and reopen Neovim...'
    vim.cmd [[packadd packer.nvim]]
end


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Have packer use a popup window
-- packer.init {
--     display = {
--         open_fn = function()
--             return require('packer.util').float { border = 'rounded' }
--         end,
--     },
-- }

-- Install your plugins here
return packer.startup(function(use)
    use 'wbthomason/packer.nvim'            -- packer can manage itself
    use 'nvim-lua/plenary.nvim'             -- made by tj, used by many plugins
    use 'lewis6991/impatient.nvim'          -- speed up nvim startup (TODO: what is this)

    use 'windwp/nvim-autopairs'             -- automatically close brackets
    use 'mbbill/undotree'                   -- see the undo history

    -- File Browser
    use 'kyazdani42/nvim-tree.lua'          -- nerdtree 2.0 for neovim
    use 'kyazdani42/nvim-web-devicons'      -- for icons almost everywhere

    -- Toggleterm
    use 'akinsho/toggleterm.nvim'           -- toggle terminal from neovim

    -- Git
    use 'tpope/vim-fugitive'                -- vim git integration, thanks tpope
    use 'lewis6991/gitsigns.nvim'           -- super fast git decorations

    -- Comments
    use 'numToStr/Comment.nvim'             -- easy comment written in lua
    use 'JoosepAlviste/nvim-ts-context-commentstring' -- support jsx commenting

    -- Colorschemes & Statuslines
    use {
        'catppuccin/nvim',                  -- nice colorscheme, thanks tj
        as = 'catppuccin'
    }
    use 'nvim-lualine/lualine.nvim'         -- great status line in lua
    use 'lukas-reineke/indent-blankline.nvim' -- add indent guides for Neovim

    -- CMP plugins
    use 'hrsh7th/nvim-cmp'                  -- the completion plugin
    use 'hrsh7th/cmp-buffer'                -- buffer completions
    use 'hrsh7th/cmp-path'                  -- path completions
    use 'hrsh7th/cmp-cmdline'               -- cmdline completions
    use 'saadparwaiz1/cmp_luasnip'          -- snippet completions
    use 'hrsh7th/cmp-nvim-lsp'              -- get the LSP completion
    use 'hrsh7th/cmp-nvim-lua'              -- get the LSP for lua in nvim config

    -- Snippets
    use 'L3MON4D3/LuaSnip'                  -- snippet engine
    use 'rafamadriz/friendly-snippets'      -- some vscode snippets to use

    -- LSP
    use 'neovim/nvim-lspconfig'             -- LSP configurations
    use 'williamboman/nvim-lsp-installer'   -- add LspInstall <language>
    use 'jose-elias-alvarez/null-ls.nvim'   -- code formatter (LSP diagnostics, code actions, and more)

    -- Telescope
    use 'nvim-telescope/telescope.nvim'     -- the goat
    use {
        'nvim-telescope/telescope-fzf-native.nvim', -- fzf for telescope
        run = 'make'
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Useful tools
    -- To preview markdown files in browser
    use {
        'iamcco/markdown-preview.nvim',
        run = 'npm install --global yarn && cd app && yarn install',
        ft = { 'markdown' },
        cmd = 'MarkdownPreview'
    }
    -- To preview HTML, CSS and JS in browser
    use {
        'turbio/bracey.vim',
        run = 'npm install --prefix server',
        cmd = 'Bracey'
    }
    use 'norcalli/nvim-colorizer.lua'       -- preview colors in neovim

    use 'tweekmonster/startuptime.vim'      -- check the startuptime of plugins

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
