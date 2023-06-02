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

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-------------------------------------------------------------------------------
-- Fonts to try:
-- "MonoLisa Nerd Font",
-- "SF Mono",
-- "DankMono Nerd Font",
-- "Monego Ligatures",
-- "Comic Code Ligatures",
-- "Operator Mono Lig",
-- "Gintronic",
-- "Cascadia Code",
-- "FiraCode Nerd Font Mono",
-- "Victor Mono",
-- "Inconsolata",
-- "TempleOS",
-- "Apercu Pro"

-- List available fonts: wezterm ls-fonts --list-system
local fonts = {
    "BlexMono Nerd Font Mono",
    "Cascadia Code",
    "JetBrainsMono Nerd Font Mono",
    "JetBrains Mono", -- pre-installed
}

config.font = wezterm.font_with_fallback({ fonts[1], fonts[#fonts] })
config.font_size = 13.0

config.window_background_opacity = 0.85
-- config.color_scheme = "Catppuccin Macchiato"

-- https://github.com/samuelngs/apple-emoji-linux/releases/tag/v16.4
-- local emoji_fonts={ "Apple Color Emoji", "Joypixels", "Twemoji", "Noto Color Emoji", "Noto Emoji" }
-- config.font = wezterm.font_with_fallback({ fonts[1], emoji_fonts[1], emoji_fonts[2] })

-- https://www.monolisa.dev/playground
-- config.harfbuzz_features = { "calt", "liga", "zero", "-ss01", "ss02", "-ss03", "ss04", "ss05", "ss06", "ss07", "-ss08", "-ss09" }
-- to disable something add =0 to the end or - at the beginning
config.harfbuzz_features = {
    "calt", -- Ligatures -> <=> ===
    -- "zero" -- 0
}

-- config.automatically_reload_config = true
config.disable_default_key_bindings = true
config.enable_tab_bar = false
-- config.show_new_tab_button_in_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab= false
-- config.enable_scroll_bar = false

config.default_cursor_style = "BlinkingBar" -- SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, or BlinkingBar

config.scrollback_lines = 5000 -- default: 3500

-- config.window_padding = {
--     left = 30,
--     right = 30,
--     top = 30,
--     bottom = 30,
-- }

-----------------------------------------------------------------------------------------------------------------------
-- Keybindings
-----------------------------------------------------------------------------------------------------------------------
local act = wezterm.action

config.keys = {
    -- Font Size
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "_", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    { key = "0", mods = "SHIFT|CTRL", action = act.ResetFontSize },
    { key = ")", mods = "CTRL", action = act.ResetFontSize },
    { key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },

    -- Copy and Paste
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },

    { key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
    { key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    -- { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
}

-----------------------------------------------------------------------------------------------------------------------

-- and finally, return the configuration to wezterm
return config
