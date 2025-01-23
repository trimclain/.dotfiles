return {
    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other
    -- instances.
    {
        "RRethy/vim-illuminate",
        cond = CONFIG.plugins.illuminate,
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            vim.keymap.set("n", "<leader>oi", function()
                require("illuminate").toggle()
            end, { desc = "Toggle Vim [I]lluminate" })

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })

            -- replace underline with highlight (no need since astrotheme supports this now)
            -- local hl = vim.api.nvim_set_hl
            -- local color = "#31363d" -- color taken from primer.nvim
            -- hl(0, "IlluminatedWordRead", { fg = "NONE", bg = color })
            -- hl(0, "IlluminatedWordWrite", { fg = "NONE", bg = color })
            -- hl(0, "IlluminatedWordText", { fg = "NONE", bg = color })
        end,
    },
}
