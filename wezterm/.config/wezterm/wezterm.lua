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
}

config.font = wezterm.font_with_fallback({ fonts[1], fonts[2] })
config.font_size = 13.0

config.window_background_opacity = 0.85
-- config.color_scheme = "AdventureTime"

-- https://github.com/samuelngs/apple-emoji-linux/releases/tag/v16.4
-- local emoji_fonts={ "Apple Color Emoji", "Joypixels", "Twemoji", "Noto Color Emoji", "Noto Emoji" }
-- config.font = wezterm.font_with_fallback({ fonts[1], emoji_fonts[1], emoji_fonts[2] })

-- -> <=>
-- https://www.monolisa.dev/playground
-- config.harfbuzz_features = { "calt", "liga", "zero", "-ss01", "ss02", "-ss03", "ss04", "ss05", "ss06", "ss07", "-ss08", "-ss09" }

-- config.disable_default_key_bindings = true
-- config.enable_scroll_bar = false
-- config.scrollback_lines = 10240
-- config.enable_tab_bar = true
-- config.hide_tab_bar_if_only_one_tab= false
-- config.automatically_reload_config = true
-- config.show_new_tab_button_in_tab_bar = false

-------------------------------------------------------------------------------

-- and finally, return the configuration to wezterm
return config
