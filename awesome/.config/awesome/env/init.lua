local awful = require("awful") -- Everything related to window managment

local M = {}

M.modkey = "Mod1" -- ALT key
M.altkey = "Mod4" -- SUPER key

M.detect_terminal = require("env.terminal").get_name
M.detect_editor = require("env.editor").get_name
M.detect_browser = require("env.browser").get_name

M.run_launcher = require("env.launcher").run_launcher
M.app_launcher = require("env.launcher").app_launcher

M.launch_sysmon = require("env.sysmon").spawn

M.enable_titlebars = false
M.border_radius = 7 -- default: 10

-- Table of layouts to cover with awful.layout.inc, order matters.
M.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,

    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
}

return M
