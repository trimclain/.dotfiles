-- preview HTML, CSS and JS in browser
return {
    {
        "turbio/bracey.vim",
        enabled = vim.fn.executable("npm") == 1,
        build = "npm ci --prefix server", -- Lazy sync doesn't run `git restore .` so it can't pull.
        ft = "html",
        cmd = "Bracey",
        keys = {
            { "<leader>mb", "<cmd>Bracey<cr>", desc = "Open Preview (Live Server)" },
        },
        config = function()
            -- Open preview in a new window
            -- TODO: fix hardcoded browser
            vim.g.bracey_browser_command = "brave-browser --new-window"
        end,
    },
}
