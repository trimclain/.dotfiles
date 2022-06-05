local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
    return
end

local icons = require "trimclain.icons"

local space = ""
if vim.fn.has "mac" == 1 then
    space = " "
end

-- Customized config
gps.setup {

    disable_icons = false, -- Setting it to true will disable all icons

    icons = {
        ["class-name"] = "%#CmpItemKindClass#" .. icons.kind.Class .. "%*" .. space, -- Classes and class-like objects
        ["function-name"] = "%#CmpItemKindFunction#" .. icons.kind.Function .. "%*" .. space, -- Functions
        ["method-name"] = "%#CmpItemKindMethod#" .. icons.kind.Method .. "%*" .. space, -- Methods (functions inside class-like objects)
        ["container-name"] = "%#CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space, -- Containers (example: lua tables)
        ["tag-name"] = "%#CmpItemKindKeyword#" .. icons.misc.Tag .. "%*" .. " ", -- Tags (example: html tags)
        ["mapping-name"] = "%#CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space,
        ["sequence-name"] = "%#CmpItemKindProperty#" .. icons.type.Array .. "%*" .. space,
        ["null-name"] = "%#CmpItemKindField#" .. icons.kind.Field .. "%*" .. space,
        ["boolean-name"] = "%#CmpItemKindValue#" .. icons.type.Boolean .. "%*" .. space,
        ["integer-name"] = "%#CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
        ["float-name"] = "%#CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
        ["string-name"] = "%#CmpItemKindValue#" .. icons.type.String .. "%*" .. space,
        ["array-name"] = "%#CmpItemKindProperty#" .. icons.type.Array .. "%*" .. space,
        ["object-name"] = "%#CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space,
        ["number-name"] = "%#CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
        ["table-name"] = "%#CmpItemKindProperty#" .. icons.ui.Table .. "%*" .. space,
        ["date-name"] = "%#CmpItemKindValue#" .. icons.ui.Calendar .. "%*" .. space,
        ["date-time-name"] = "%#CmpItemKindValue#" .. icons.ui.Table .. "%*" .. space,
        ["inline-table-name"] = "%#CmpItemKindProperty#" .. icons.ui.Calendar .. "%*" .. space,
        ["time-name"] = "%#CmpItemKindValue#" .. icons.misc.Watch .. "%*" .. space,
        ["module-name"] = "%#CmpItemKindModule#" .. icons.kind.Module .. "%*" .. space,
    },

    -- Add custom configuration per language or
    -- Disable the plugin for a language
    -- Any language not disabled here is enabled by default
    -- languages = {
    --     -- Some languages have custom icons
    --     ["json"] = {
    --         icons = {
    --             ["array-name"] = " ",
    --             ["object-name"] = " ",
    --             ["null-name"] = "[] ",
    --             ["boolean-name"] = "ﰰﰴ ",
    --             ["number-name"] = "# ",
    --             ["string-name"] = " ",
    --         },
    --     },
    --     ["latex"] = {
    --         icons = {
    --             ["title-name"] = "# ",
    --             ["label-name"] = " ",
    --         },
    --     },
    --     ["norg"] = {
    --         icons = {
    --             ["title-name"] = " ",
    --         },
    --     },
    --     ["toml"] = {
    --         icons = {
    --             ["table-name"] = " ",
    --             ["array-name"] = " ",
    --             ["boolean-name"] = "ﰰﰴ ",
    --             ["date-name"] = " ",
    --             ["date-time-name"] = " ",
    --             ["float-name"] = " ",
    --             ["inline-table-name"] = " ",
    --             ["integer-name"] = "# ",
    --             ["string-name"] = " ",
    --             ["time-name"] = " ",
    --         },
    --     },
    --     ["verilog"] = {
    --         icons = {
    --             ["module-name"] = " ",
    --         },
    --     },
    --     ["yaml"] = {
    --         icons = {
    --             ["mapping-name"] = " ",
    --             ["sequence-name"] = " ",
    --             ["null-name"] = "[] ",
    --             ["boolean-name"] = "ﰰﰴ ",
    --             ["integer-name"] = "# ",
    --             ["float-name"] = " ",
    --             ["string-name"] = " ",
    --         },
    --     },
    --     ["yang"] = {
    --         icons = {
    --             ["module-name"] = " ",
    --             ["augment-path"] = " ",
    --             ["container-name"] = " ",
    --             ["grouping-name"] = " ",
    --             ["typedef-name"] = " ",
    --             ["identity-name"] = " ",
    --             ["list-name"] = "﬘ ",
    --             ["leaf-list-name"] = " ",
    --             ["leaf-name"] = " ",
    --             ["action-name"] = " ",
    --         },
    --     },

    -- Disable for particular languages
    -- ["bash"] = false, -- disables nvim-gps for bash
    -- ["go"] = false, -- disables nvim-gps for golang

    -- Override default setting for particular languages
    -- ["ruby"] = {
    --     separator = "|", -- Overrides default separator with '|'
    --     icons = {
    --         -- Default icons not specified in the lang config
    --         -- will fallback to the default value
    --         -- "container-name" will fallback to default because it's not set
    --         ["function-name"] = "", -- to ensure empty values, set an empty string
    --         ["tag-name"] = "",
    --         ["class-name"] = "::",
    --         ["method-name"] = "#",
    --     },
    -- },
    -- },

    separator = " " .. icons.ui.ChevronRight .. " ",

    -- limit for amount of context shown
    -- 0 means no limit
    depth = 0,

    -- indicator used when context hits depth limit
    depth_limit_indicator = "..",
    text_hl = "LineNr", -- only for the gps with color
}
