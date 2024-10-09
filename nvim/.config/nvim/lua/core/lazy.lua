-- Install lazy.nvim if needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    -- install lazy.nvim
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Make space a leader key. This needs to happen before lazy.nvim setup.
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically sourced
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
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false, -- maybe later
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
