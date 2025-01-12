local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- yes, this does work on Windows
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- set a leader key before lazy.nvim setup
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically imported
require("lazy").setup("plugins", {
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = false, -- always use the latest git commit
    },
    dev = {
        path = "~/projects/personal",
        fallback = true, -- fallback to git when local plugin doesn't exist
    },
    -- try to load one of these colorschemes when starting an installation during startup
    install = { colorscheme = { CONFIG.ui.colorscheme, "habamax" } },
    ui = { border = CONFIG.ui.border },
    checker = {
        -- automatically check for plugin updates
        enabled = false,
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false,
        -- notify = false, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            -- disable builtin plugins I don't use
            disabled_plugins = {
                "gzip", -- read *.Z, *.gz, *.bz2, *.lzma, *.xz, *.lz and *.zst files in vim
                -- "matchit", -- better % matches
                "matchparen", -- highlight matching parentheses
                "netrwPlugin", -- builtin file explorer
                "rplugin", -- remote plugin support
                "tarPlugin", -- read *.tar files in vim
                "tohtml", -- convert current window to html
                "tutor", -- vim tutor
                "zipPlugin", -- read *.zip files in vim
            },
        },
    },
})
