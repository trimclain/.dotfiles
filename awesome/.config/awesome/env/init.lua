local awful = require("awful") -- Everything related to window managment

local M = {}

M.modkey = "Mod1" -- ALT key
M.altkey = "Mod4" -- SUPER key

M.detect_terminal = require("env.terminal").get_name
M.editor = os.getenv("EDITOR") or "nvim"
M.gui_editor = "neovide"
M.browser = "thorium-browser"

M.run_launcher = require("env.launcher").run_launcher
M.app_launcher = require("env.launcher").app_launcher

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

-- vim:foldmethod=marker
