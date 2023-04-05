return {
    -- the colorscheme should be available when starting Neovim
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- local plugins need to be explicitly configured with dir
    ---{ dir = "~/projects/secret.nvim" },

    -- you can use a custom url to fetch a plugin
    ---{ url = "git@github.com:folke/noice.nvim.git" },

    -- local plugins can also be configure with the dev option.
    -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from Github
    -- With the dev option, you can easily switch between the local and installed version of a plugin
    ---{ "folke/noice.nvim", dev = true },
}
