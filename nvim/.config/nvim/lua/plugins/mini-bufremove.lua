-- Save the window layout when closing a buffer.
return {
    {
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<leader>q",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "Delete Buffer",
            },
        },
    },
}
