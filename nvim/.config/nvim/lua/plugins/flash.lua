-- easier jumps with f,F,t,T
return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            label = {
                rainbow = {
                    enabled = false,
                },
            },
            modes = {
                char = {
                    jump_labels = true,
                    multi_line = false,
                    highlight = { backdrop = false },
                },
            },
        },
    },
}
