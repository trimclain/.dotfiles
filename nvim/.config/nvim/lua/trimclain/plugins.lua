local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- Automatically install packer
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer, close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    use "wbthomason/packer.nvim" -- packer can manage itself
    use "nvim-lua/plenary.nvim" -- made by tj, used by many plugins
    use "lewis6991/impatient.nvim" -- speed up nvim startup

    use "windwp/nvim-autopairs" -- autoclose brackets
    use "windwp/nvim-ts-autotag" -- autoclose and autorename html tags
    use "mbbill/undotree" -- see the undo history

    use "karb94/neoscroll.nvim" -- smooth scrolling
    use {
        "phaazon/hop.nvim", -- easier jumps with f,F,t,T
        branch = "v2", -- optional but strongly recommended
    }

    -- File Browser
    use "kyazdani42/nvim-tree.lua" -- nerdtree 2.0 for neovim
    use "kyazdani42/nvim-web-devicons" -- for icons almost everywhere

    -- Toggleterm
    use "akinsho/toggleterm.nvim" -- toggle terminal from neovim

    -- Git
    -- TODO: checkout neogit to go full lua
    use "tpope/vim-fugitive" -- vim git integration, thanks tpope
    use "lewis6991/gitsigns.nvim" -- super fast git decorations

    -- Comments
    use "numToStr/Comment.nvim" -- easy comment written in lua
    use "JoosepAlviste/nvim-ts-context-commentstring" -- support jsx commenting
    use "folke/todo-comments.nvim" -- highlight todo comments in different styles

    -- Colorschemes
    use {
        "catppuccin/nvim", -- nice colorscheme, thanks tj
        as = "catppuccin",
    }
    use {
        "dracula/vim",
        as = "dracula",
    }
    use "arzg/vim-colors-xcode" -- xcode 11's colorscheme
    use "folke/tokyonight.nvim" -- trying this one out
    -- use "christianchiarulli/nvcode-color-schemes.vim" -- nice collection
    use "LunarVim/Colorschemes" -- another colorscheme collection from chris
    -- use "gruvbox-community/gruvbox"
    -- use "luisiacc/gruvbox-baby"
    -- Testing Colorschemes
    use "sainnhe/sonokai"
    use "EdenEast/nightfox.nvim"
    use "glepnir/zephyr-nvim"

    -- Statusline & other visuals
    use "nvim-lualine/lualine.nvim" -- great status line in lua
    use "lukas-reineke/indent-blankline.nvim" -- add indent guides for Neovim
    use { "akinsho/bufferline.nvim", tag = "v2.*" } -- add bufferline to show open buffers
    use "famiu/bufdelete.nvim" -- properly close a buffer and don't ruin my layout
    use "j-hui/fidget.nvim" -- UI for nvim-lsp's progress handler (loading animation at startup on bottom right)
    use "folke/which-key.nvim" -- displays a popup with possible key bindings of the command you started typing

    -- TODO: navic is very alpha right now, wait until it's usable
    -- use "SmiteshP/nvim-navic" -- show context of the current cursor position in file
    use {
        "christianchiarulli/nvim-gps", -- gps but with color support
        branch = "text_hl",
    }

    -- CMP plugins
    use "hrsh7th/nvim-cmp" -- the completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp" -- get the LSP completion
    use "hrsh7th/cmp-nvim-lua" -- get the LSP for lua in nvim config

    -- Snippets
    use "L3MON4D3/LuaSnip" -- snippet engine
    use "rafamadriz/friendly-snippets" -- some vscode snippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- LSP configurations
    use "williamboman/mason.nvim" -- manage external editor tooling such as LSP servers, DAP servers, linters, and formatters
    use "williamboman/mason-lspconfig.nvim" -- bridge mason.nvim with the lspconfig
    -- use "williamboman/nvim-lsp-installer" -- add LspInstall <language>
    use "jose-elias-alvarez/null-ls.nvim" -- code formatter (LSP diagnostics, code actions, and more)
    -- TODO: do I want these?
    -- use "jayp0521/mason-null-ls.nvim" -- bridge mason.nvim with the null-ls
    -- use "RubixDev/mason-update-all" -- easily update all Mason packages with one command
    use "ray-x/lsp_signature.nvim" -- show function signature when you type

    -- Telescope
    use "nvim-telescope/telescope.nvim" -- the goat
    use {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf for telescope
        run = "make",
    }

    -- Harpoon
    use "ThePrimeagen/harpoon" -- thanks Prime

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    -- Useful tools
    -- To preview print statement outputs in neovim (for JS, TS, Python and Lua)
    use {
        "0x100101/lab.nvim",
        run = "cd js && npm ci",
    }

    -- To preview markdown files in browser
    use {
        "iamcco/markdown-preview.nvim",
        run = "npm install --global yarn && cd app && yarn install",
        ft = { "markdown" },
        cmd = "MarkdownPreview",
    }
    -- To preview HTML, CSS and JS in browser
    use {
        "turbio/bracey.vim",
        run = "npm install --prefix server",
        cmd = "Bracey",
    }
    use "norcalli/nvim-colorizer.lua" -- preview colors in neovim
    use "KabbAmine/vCoolor.vim" -- get a color picker

    use "dstein64/vim-startuptime" -- check the startuptime of plugins
    -- use "tweekmonster/startuptime.vim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
