local awful = require("awful") -- Everything related to window managment

local env = require("env")

-- make sure that there's always a client that will have focus on events such as tag switching, client unmanaging, etc.
require("awful.autofocus")

-- handle errors during and after startup
require("core.errors")

-- local naughty = require("naughty") -- Notification library
-- naughty.config.defaults["icon_size"] = 100 -- otherwise the notification popup is too big

-- Layouts to cycle through with awful.layout.inc, first one being the default
awful.layout.layouts = env.layouts
