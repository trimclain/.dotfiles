-- TODO: where to put the others?
return {

    -- search/replace in multiple files
    {
        "nvim-pack/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
            { "<leader>rw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Replace Word (Spectre)" },
            { "<leader>rf", function() require("spectre").open_file_search() end, desc = "Replace Buffer (Spectre)" },
        },
    },

    -- Alternative: "stevearc/quicker.nvim"
    -- TODO: someday
    -- better diagnostics list and others
    -- {
    --     "folke/trouble.nvim",
    --     cmd = { "TroubleToggle", "Trouble" },
    --     opts = { use_diagnostic_signs = true },
    --     keys = {
    --         { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    --         { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    --         { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    --         { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    --         {
    --             "[q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").previous({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cprev()
    --                 end
    --             end,
    --             desc = "Previous trouble/quickfix item",
    --         },
    --         {
    --             "]q",
    --             function()
    --                 if require("trouble").is_open() then
    --                     require("trouble").next({ skip_groups = true, jump = true })
    --                 else
    --                     vim.cmd.cnext()
    --                 end
    --             end,
    --             desc = "Next trouble/quickfix item",
    --         },
    --     },
    -- },

    -- zen mode
    {
        "folke/zen-mode.nvim",
        -- dependencies = {
        --     -- twilight
        --     {
        --         "folke/twilight.nvim",
        --         opts = {
        --             alpha = 0.25, -- amount of dimming
        --         },
        --     },
        -- },
        cmd = "ZenMode",
        -- stylua: ignore
        keys = {
            { "<leader>z", function() require("zen-mode").toggle() end, desc = "Toggle Zen Mode" }
        },
        opts = {
            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = false,
                font = "+4", -- font size increment
            },
        },
    },

    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other
    -- instances.
    {
        "RRethy/vim-illuminate",
        cond = CONFIG.plugins.illuminate,
        event = { "BufReadPost", "BufNewFile" },
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
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- auto remove search highlight and rehighlight when using n or N
    -- {
    --     "nvimdev/hlsearch.nvim",
    --     config = true,
    -- },

    -- incsearch for :linenum<cr>
    -- {
    --     "nacro90/numb.nvim",
    --     event = "BufReadPost",
    --     config = true,
    -- },
}
