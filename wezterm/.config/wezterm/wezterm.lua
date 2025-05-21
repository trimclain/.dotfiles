-------------------------------------------------------------------------------
--                                                                           --
--   ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗    --
--   ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║    --
--      ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║    --
--      ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║    --
--      ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║    --
--      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    --
--                                                                           --
--       Arthur McLain (trimclain)                                           --
--       mclain.it@gmail.com                                                 --
--       https://github.com/trimclain                                        --
--                                                                           --
-------------------------------------------------------------------------------

-- Docs: https://wezfurlong.org/wezterm/config/files.html#configuration-files

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- {{{ Fonts
-- List available fonts: wezterm ls-fonts --list-system
-- INFO: gucharmap is a great app for searching missing glyphs
-- Another great method:
--   `wezterm ls-fonts --codepoints "e6b8"` for missing \u{e6b8} or
--   `wezterm ls-fonts --text ""` with pasted icon
local fonts = {
    geist = "GeistMono Nerd Font Mono", -- has no italics
    maple = "Maple Mono NF",
    cascadia = {
        { family = "CaskaydiaCove Nerd Font Mono", weight = "DemiLight", stretch = "Normal", style = "Normal" },
        { family = "CaskaydiaCove Nerd Font Mono", weight = "DemiLight", stretch = "Normal", style = "Italic" },
        { family = "CaskaydiaCove Nerd Font Mono", weight = "DemiBold", stretch = "Normal", style = "Normal" },
        { family = "CaskaydiaCove Nerd Font Mono", weight = "DemiBold", stretch = "Normal", style = "Italic" },
    },
    blex = "BlexMono Nerd Font Mono",
    jetbrains = "JetBrainsMono Nerd Font Mono",
    -- "JetBrains Mono", -- pre-installed
}
-- config.font = wezterm.font(fonts.maple) -- takes a string
-- Apparently \u{e6b8} is missing in MapleMonoNF, so use fallback for now
config.font = wezterm.font_with_fallback({ fonts.maple, fonts.geist }) -- takes a table
config.font_size = 14.0

-- https://learn.microsoft.com/en-us/typography/opentype/spec/featurelist
-- config.harfbuzz_features = { "calt", "liga", "zero", "-ss01", "ss02", "-ss03", "ss04", "ss05", "ss06", "ss07", "-ss08", "-ss09" }
-- to disable something add =0 to the end or - at the beginning
config.harfbuzz_features = {
    "calt=0", -- Ligatures -> <=> ===
    "liga=0",
    "clig=0",
    -- "zero" -- 0
}
-- }}}

-- {{{ General
-- Docs: https://wezfurlong.org/wezterm/config/lua/config/window_padding.html
-- config.window_padding = {
--     left = 30,
--     right = 30,
--     top = 30,
--     bottom = 30,
-- }

-- config.automatically_reload_config = false
config.adjust_window_size_when_changing_font_size = false

config.audible_bell = "Disabled" -- default: "SystemBeep"

-- Disable the title bar but enable the resizable border
-- config.window_decorations = "RESIZE"

-- Extra: https://wezfurlong.org/wezterm/config/lua/config/win32_system_backdrop.html
-- config.window_background_opacity = 0.85

-- config.enable_tab_bar = false
-- config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- config.enable_scroll_bar = false

-- Docs: https://wezfurlong.org/wezterm/config/lua/config/animation_fps.html
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.scrollback_lines = 5000 -- default: 3500

config.default_cursor_style = "SteadyBar" -- SteadyBlock (default), BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, or BlinkingBar

-- -- Use wezterm.gui.enumerate_gpus() in Debug Overlay (ctrl+shift+l) to see the list
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- -- config.webgpu_force_fallback_adapter = true
-- config.front_end = "WebGpu" -- OpenGL (default), Software (CPU), WebGpu (DirectX 12 on Windows)

config.check_for_updates = false
-- }}}

-- {{{ Colorscheme
-- config.color_scheme = "Campbell (Gogh)"
config.color_scheme = "Dark Pastel"
config.colors = { background = "#1A1D23" } -- match astrotheme background
-- }}}

-- {{{ Keybindings

-- config.disable_default_mouse_bindings = true

-- INFO: to check default keys
-- https://wezfurlong.org/wezterm/config/default-keys.html
-- or
-- wezterm show-keys --lua (after commenting line below)
config.disable_default_key_bindings = true

-- INFO: available keybind commands
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html#available-key-assignments
local act = wezterm.action
config.keys = {
    -- Font Size
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },

    -- Copy and Paste
    { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },

    -- Tabs
    { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },

    -- Debug Overlay and Command Palette
    { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
}
--- }}}

return config

-- vim:fileencoding=utf-8:foldmethod=marker
