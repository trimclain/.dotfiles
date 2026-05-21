local gears = require("gears") -- Utilities such as color parsing and objects
local beautiful = require("beautiful") -- Theme handling library

local M = {}

function M.setup(s)
    -- TODO: it's better to pass the wallpaper to make it more modular
    -- This would also remove the beautiful call which I want to achieve anyway
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

return M
