-- search/replace in multiple files
return {
    {
        "nvim-pack/nvim-spectre",
        enabled = vim.fn.executable("sed") == 1,
        cond = false, -- currently trying out grug
        -- stylua: ignore
        keys = {
            { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
            { "<leader>rw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Replace Word (Spectre)" },
            { "<leader>rf", function() require("spectre").open_file_search() end, desc = "Replace Buffer (Spectre)" },
        },
    },

    {
        "MagicDuck/grug-far.nvim",
        enabled = vim.fn.executable("rg") == 1,
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>rr",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true, -- launch as a unlisted buffer that fully deletes itself when not in use
                        keymaps = { help = "?" },
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                            flags = "--hidden",
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },
}
