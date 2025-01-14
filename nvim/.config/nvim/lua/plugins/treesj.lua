-- Split/join blocks of code.
return {
    {
        "Wansmer/treesj",
        dependencies = "nvim-treesitter",
        keys = {
            { "gs", "<cmd>TSJToggle<cr>", desc = "Toggle SplitJoin" }, -- defailt gs is :sleep (kinda useless)
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },
}
