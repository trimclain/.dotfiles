local gears = require("gears") -- Utilities such as color parsing and objects
local beautiful = require("beautiful") -- Theme handling library

local utils = require("utils")

local M = {}

---@class awesome.screen
---@field index integer

--- Set the wallpaper using gears.wallpaper
---@param screen awesome.screen screen on which to set the wallpaper
---@param wallpaper? string path to wallpaper
function M.setup(screen, wallpaper)
    wallpaper = wallpaper or beautiful.wallpaper
    if not wallpaper then
        utils.notify("Wallpaper wasn't set in the theme.", { title = "Awesome Wallpaper Setter", preset = "critical" })
        return
    end
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(screen)
    end
    gears.wallpaper.maximized(wallpaper, screen, true)
end

return M
