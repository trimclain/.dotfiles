local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local menu = require("ui.menu")

local M = {}

-- Mouse Buttons
-- 1 - leftclick, 2 - middleclick, 3 - rightclick, 4 - wheel up, 5 - wheel down
M.buttons = gears.table.join(
    awful.button({}, 3, function()
        menu.main_menu:toggle()
    end)
    -- scroll to move me to next tag
    -- awful.button({}, 4, awful.tag.viewprev),
    -- awful.button({}, 5, awful.tag.viewnext)
)

-- Keyboard Shortcuts
M.keys = gears.table.join(
    require("binds.global.launcher"),
    require("binds.global.awesome"),
    require("binds.global.client"),
    -- TODO:
    -- require("binds.global.screen"),
    require("binds.global.layout"),
    require("binds.global.hotkeys"),
    require("binds.global.tags"),
    require("binds.global.modal")
)

return M
