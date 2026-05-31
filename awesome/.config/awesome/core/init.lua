local awful = require("awful") -- Everything related to window managment

local env = require("env")

-- make sure that there's always a client that will have focus on events such as tag switching, client unmanaging, etc.
require("awful.autofocus")

-- handle errors during and after startup
require("core.errors")

-- Layouts to cycle through with awful.layout.inc, first one being the default
awful.layout.layouts = env.layouts
