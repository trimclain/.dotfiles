-- preview HTML, CSS and JS in browser
-- Alternative: "brianhuster/live-preview.nvim"
return {
    {
        "turbio/bracey.vim",
        -- NOTE: needs python3-pynvim installed
        enabled = vim.fn.executable("npm") == 1,
        build = "npm ci --prefix server", -- Lazy sync doesn't run `git restore .` so it can't pull.
        ft = "html",
        cmd = "Bracey",
        keys = {
            { "<leader>mb", "<cmd>Bracey<cr>", desc = "Open Preview (Live Server)" },
        },
        config = function()
            -- Detect installed browser
            local browserlist = {
                "thorium-browser",
                "google-chrome",
                "brave",
                "brave-browser",
            }
            for _, browser in ipairs(browserlist) do
                if vim.fn.executable(browser) == 1 then
                    -- Open preview in a new window
                    vim.g.bracey_browser_command = browser .. " --new-window"
                    break
                end
            end
        end,
    },
}
