local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tag_keys = {}
-- WARN: not all 9 are always defined
for i = 1, 9 do
    -- View tag only.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey }, "#" .. i + 9, function()
        local s = awful.screen.focused()
        local tag = s.tags[i]
        if tag then
            tag:view_only()
        end
    end, { description = "view tag #" .. i, group = "tag" })
    -- Toggle tag display.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control" }, "#" .. i + 9, function()
        local s = awful.screen.focused()
        local tag = s.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, { description = "toggle tag #" .. i, group = "tag" })
    -- Move client to tag.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, { description = "move focused client to tag #" .. i, group = "tag" })
    -- -- Toggle tag on focused client.
    -- tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control", "Shift" }, "#" .. i + 9, function()
    --     if client.focus then
    --         local tag = client.focus.screen.tags[i]
    --         if tag then
    --             client.focus:toggle_tag(tag)
    --         end
    --     end
    -- end, { description = "toggle focused client on tag #" .. i, group = "tag" })
end

return gears.table.join(table.unpack(tag_keys))
