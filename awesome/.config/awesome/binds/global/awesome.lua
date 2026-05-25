local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects
local hotkeys_popup = require("awful.hotkeys_popup")

local env = require("env")
local utils = require("utils")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

return gears.table.join(
    awful.key({ env.modkey }, "/", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ env.modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ env.modkey, "Shift" }, "e", awesome.quit, { description = "exit awesome", group = "awesome" }),
    -- TODO: run_command can return a function so I can stop wrapping stuff around
    awful.key({ env.modkey }, "0", function()
        utils.run_command("~/.local/bin/powermenu")
    end, { description = "open power menu", group = "awesome" })
    -- awful.key({ env.modkey }, "m", function()
    --     menu.main_menu:show()
    -- end, { description = "show main menu", group = "awesome" }),

    -- awful.key({ modkey }, "x", function()
    --     awful.prompt.run({
    --         prompt = "Run Lua code: ",
    --         textbox = awful.screen.focused().mypromptbox.widget,
    --         exe_callback = awful.util.eval,
    --         history_path = awful.util.get_cache_dir() .. "/history_eval",
    --     })
    -- end, { description = "lua execute prompt", group = "awesome" }),
)
