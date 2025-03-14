return {
    -- Plugin for automated bullet lists in markdown
    -- use "dkarter/bullets.vim"

    -- Plugin to generate table of contents for Markdown files
    -- use "mzlogin/vim-markdown-toc"

    -- preview markdown files in browser
    {
        "iamcco/markdown-preview.nvim",
        enabled = vim.fn.executable("npm") == 1,
        build = "cd app && npx --yes yarn install", -- Lazy sync doesn't run `git restore .` so it can't pull
        -- build = function() vim.fn["mkdp#util#install"]() end, # it's possible to install without npm/yarn
        -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        config = function()
            vim.g.mkdp_auto_close = 0 -- don't auto close current preview window when change to another buffer
            vim.g.mkdp_echo_preview_url = 1 -- echo preview page url in command line when open preview page

            -- Detect installed browser
            local browserlist = {
                "thorium-browser",
                "google-chrome",
                "brave",
                "brave-browser",
            }
            for _, browser in ipairs(browserlist) do
                if vim.fn.executable(browser) == 1 then
                    vim.g.mkdp_browser = browser
                    break
                end
            end

            -- Open preview in a new window
            -- doesn't work on mac: https://github.com/iamcco/markdown-preview.nvim#faq
            vim.cmd([[
                function OpenMarkdownPreview(url)
                    execute "silent ! " . g:mkdp_browser . " --new-window " . a:url
                endfunction
                let g:mkdp_browserfunc = "OpenMarkdownPreview"
            ]])

            vim.keymap.set(
                "n",
                "<leader>mp",
                "<cmd>MarkdownPreviewToggle<cr>",
                { noremap = true, silent = true, buffer = true, desc = "Toggle Markdown Preview" }
            )
        end,
    },

    -- markdown preview alternative using deno
    -- {
    --     "toppair/peek.nvim",
    --     build = "deno task --quiet build:fast",
    --     keys = {
    --         {
    --             "<leader>op",
    --             function()
    --                 local peek = require("peek")
    --                 if peek.is_open() then
    --                     peek.close()
    --                 else
    --                     peek.open()
    --                 end
    --             end,
    --             desc = "Peek (Markdown Preview)",
    --         },
    --     },
    --     opts = { theme = "light" },
    -- },
}
