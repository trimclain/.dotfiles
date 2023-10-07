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

-- Why I stopped using wezterm for now:
-- 1. After I do `nohup xdg-open "$filename" &>/dev/null &` some number of times, my PC freezes when I exit wezterm
--      There might be fixed, if I set "no_hup and no_check_jobs" options in zshrc
-- 2. When changing the font size, it also changes the windows size (can be fixed by maximizing the window)

-- As soon as these things get fixed, I'm coming back to it
-- Reasons:
-- 1. Config in Lua (I love lua)
-- 2. Easily setup fallback fonts
-- 3. Helpful error messages (for example when a char can't be rendered with my current fonts)
-- 4. Changes in config apply instantly in same window
-- 5. Supports sixel AND kitty image format
-- 5. Written in rust (btw)

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

-- INFO:
-- \u{2718} is supported in these fonts: https://www.fileformat.info/info/unicode/char/2718/fontsupport.htm
-- For now I choose DejaVu (Ubuntu uses it)

-- List available fonts: wezterm ls-fonts --list-system
local fonts = {
    "BlexMono Nerd Font Mono",
    "Cascadia Code",
    "JetBrainsMono Nerd Font Mono",
    "DejaVuSansM Nerd Font",
    "JetBrains Mono", -- pre-installed
}
config.font = wezterm.font_with_fallback({ fonts[2], fonts[#fonts - 1], fonts[#fonts] })
config.font_size = 13.0

-- local cascadia_code = {
--     { family = "Cascadia Code", weight = "Light", stretch = "Normal", style = "Normal" },
--     { family = "Cascadia Code", weight = "Light", stretch = "Normal", style = "Italic" },
--     { family = "Cascadia Code", weight = "DemiBold", stretch = "Normal", style = "Normal" },
--     { family = "Cascadia Code", weight = "DemiBold", stretch = "Normal", style = "Italic" },
-- }
-- config.font = wezterm.font_with_fallback(cascadia_code)

-- config.window_background_opacity = 0.85
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "GitHub Dark"

-- Set background to same color as neovim
config.colors = {}
config.colors.background = "#21262d"

-- https://github.com/samuelngs/apple-emoji-linux/releases/tag/v16.4
-- local emoji_fonts={ "Apple Color Emoji", "Joypixels", "Twemoji", "Noto Color Emoji", "Noto Emoji" }
-- config.font = wezterm.font_with_fallback({ fonts[1], emoji_fonts[1], emoji_fonts[2] })

-- https://learn.microsoft.com/en-us/typography/opentype/spec/featurelist
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
