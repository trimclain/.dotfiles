local awful = require("awful") -- Everything related to window managment

-- Monitor Setup
awful.screen.connect_for_each_screen(function(s)
    require("ui.wallpaper").setup(s)
    -- Make it work the way I'm used to navigating multiple monitors
    if s.index == 1 then
        awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
    elseif s.index == 2 then
        awful.tag({ "7", "8", "9" }, s, awful.layout.layouts[1])
    end
    require("ui.statusbar").setup(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    require("ui.wallpaper").setup(s)
end)
