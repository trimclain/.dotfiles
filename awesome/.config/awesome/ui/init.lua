local awful = require("awful") -- Everything related to window managment

awful.screen.connect_for_each_screen(function(s)
    require("ui.wallpaper").setup(s)
    -- TODO: make similar to qtile and hyprland
    awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
    require("ui.statusbar").setup(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    require("ui.wallpaper").setup(s)
end)
