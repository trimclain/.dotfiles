-- Great explanation of what lazy.nvim can do: https://github.com/folke/lazy.nvim#examples

-- Install lazy.nvim if needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
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
        notify = true, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile_plugin",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})
