-- refactoring btw
return {
    {
        "ThePrimeagen/refactoring.nvim",
        -- stylua: ignore
        keys = {
            { "<leader>rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block (Refactor)" },
            { "<leader>rB", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block To File (Refactor)" },
            { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Extract inline var under cursor (Refactor)" },
            { "<leader>rf", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function", mode = { "v" } },
            { "<leader>rF", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function To File", mode = { "v" } },
            { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable", mode = { "v" } },
            { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Extract Inline Variable", mode = { "v" } },
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
        },
    },
}
