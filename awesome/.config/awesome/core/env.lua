local awful = require("awful") -- Everything related to window managment

local M = {}

M.modkey = "Mod1" -- alt key
M.altkey = "Mod4" -- windows key

-- INFO: for a variable to be visible here it needs to be defined in /etc/environment
local terminal = os.getenv("TERMINAL") or "kitty" -- kitty, alacritty, wezterm, ghostty
--  apparently this is faster: https://ghostty.org/docs/linux/systemd#hyprland
M.terminal = terminal == "ghostty" and "ghostty +new-window" or terminal
M.editor = os.getenv("EDITOR") or "nvim"
M.gui_editor = "neovide"
M.browser = "thorium-browser"

M.enable_titlebars = false

-- Table of layouts to cover with awful.layout.inc, order matters.
-- TODO: (advanced) port a layout I like from hyprland
M.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

return M
