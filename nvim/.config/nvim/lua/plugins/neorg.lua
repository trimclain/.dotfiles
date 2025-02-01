-- advanced note taking, project/task management
return {
    {
        "trimclain/neorg",
        -- "nvim-neorg/neorg",
        -- commit = "086891d", -- no luarocks, thanks
        -- build = ":Neorg sync-parsers", -- this doesn't work with pinned version. I'll do this manually.
        ft = "norg",
        dependencies = {
            "plenary.nvim",
            "nvim-treesitter",
        },
        config = function()
            require("neorg").setup({
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = { -- Adds pretty icons to your documents
                        config = {
                            icon_preset = "basic", -- "basic" (default), "diamond", "varied"
                        },
                    },
                },
            })

            -- TODO: test on Windows

            -- Install neorg parsers
            local function generate_paths(base_path)
                return {
                    norg_parser = base_path .. "parser/norg.so",
                    norg_meta_parser = base_path .. "parser/norg_meta.so",
                    norg_parser_revision = base_path .. "parser-info/norg.revision",
                    norg_meta_parser_revision = base_path .. "parser-info/norg_meta.revision",
                }
            end
            local src = generate_paths(vim.fn.stdpath("data") .. "/lazy/neorg/")
            local dest = generate_paths(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/")

            for key, value in pairs(dest) do
                if vim.fn.filereadable(value) == 0 then
                    -- vim.fn.delete(dest[key])
                    vim.uv.fs_copyfile(src[key], value)
                end
            end

            vim.keymap.set("n", "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", { desc = "Toggle Neorg Concealer" })
        end,
    },
}
