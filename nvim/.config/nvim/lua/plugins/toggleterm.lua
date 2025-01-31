-- terminal
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        enabled = not jit.os:find("Windows"), -- windows has no $SHELL, could pass it in opts but don't care rn
        event = "VeryLazy",
        opts = {
            open_mapping = [[<c-\>]],
            -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            shading_factor = 2,
            direction = "float",
            float_opts = {
                border = "curved",
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            -- set terminal keymaps
            function _G.set_terminal_keymaps()
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = 0 })
            end
            vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

            -- Custom Terminals
            local function open_in_toggleterm(cmd)
                return require("toggleterm.terminal").Terminal:new({ cmd = cmd, hidden = true })
            end

            -- Node
            if vim.fn.executable("node") == 1 then
                local node = open_in_toggleterm("node")
                function _NODE_TOGGLE()
                    node:toggle()
                end
                vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", { desc = "Open Node in Terminal" })
            end

            -- Python3
            if vim.fn.executable("python3") == 1 then
                local python = open_in_toggleterm("python3")
                function _PYTHON_TOGGLE()
                    python:toggle()
                end
                vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { desc = "Open Python in Terminal" })
            end

            -- Htop
            if vim.fn.executable("htop") == 1 then
                local htop = open_in_toggleterm("htop")
                function _HTOP_TOGGLE()
                    htop:toggle()
                end
                vim.keymap.set("n", "<leader>th", "<cmd>lua _HTOP_TOGGLE()<cr>", { desc = "Open HTOP in Terminal" })
            end

            -- Lazygit
            -- if vim.fn.executable("lazygit") == 1 then
            --     local lazygit = open_in_toggleterm("lazygit")
            --     function _LAZYGIT_TOGGLE()
            --         lazygit:toggle()
            --     end
            --     -- stylua: ignore
            --     vim.keymap.set("n", "<leader>gs", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", { desc = "Open Lazygit in Terminal" })
            -- end
        end,
    },
}
