-- run/build files
return {
    {
        "trimclain/builder.nvim",
        dev = true,
        cmd = "Build",
        -- stylua: ignore
        keys = {
            {"<C-b>", function() require("builder").build() end, desc = "Build current buffer"},
            -- {"<C-m>", function() require("builder").build({ color = true }) end, desc = "Build current buffer"},
        },
        opts = {
            type = CONFIG.ui.builder_type,
            float_border = CONFIG.ui.border,
            commands = {
                c = "gcc % -o $basename.out && ./$basename.out",
                cpp = "g++ % -o $basename.out && ./$basename.out",
                go = {
                    cmd = "go run %",
                    alt = "go build % && ./$basename",
                },
                java = "java %",
                javascript = "node %",
                julia = "julia %",
                -- lua = "lua %", -- this will override the `enable_builtin` for lua
                -- markdown = "glow %", -- needs color=true
                python = "python3 %",
                rust = "cargo run",
                sh = "sh %",
                tex = "tectonic --chatter=minimal %",
                typescript = "ts-node %",
                zsh = "zsh %",
            },
        },
    },
}
