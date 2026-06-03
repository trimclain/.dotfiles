local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local env = require("env")

---Find a tag by its visible name across all currently connected screens.
---@param name string Tag name to search for, for example "1" or "7".
---@return table|nil tag The matching tag object, or nil if no such tag exists.
local function find_tag_by_name(name)
    for s in screen do
        for _, t in ipairs(s.tags) do
            if t.name == name then
                return t
            end
        end
    end
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tag_keys = {}

for i = 1, 9 do
    local name = tostring(i)

    -- View tag only.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey }, "#" .. i + 9, function()
        local tag = find_tag_by_name(name)
        if tag then
            awful.screen.focus(tag.screen)
            tag:view_only()
        end
    end, { description = "view tag #" .. name, group = "tag" })

    -- Toggle tag display.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control" }, "#" .. i + 9, function()
        local tag = find_tag_by_name(name)
        if tag then
            awful.screen.focus(tag.screen)
            awful.tag.viewtoggle(tag)
        end
    end, { description = "toggle tag #" .. name, group = "tag" })

    -- Move client to tag.
    tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = find_tag_by_name(name)
            if tag then
                client.focus:move_to_tag(tag)
                -- awful.screen.focus(tag.screen)
                -- tag:view_only()
            end
        end
    end, { description = "move focused client to tag #" .. name, group = "tag" })

    -- -- Toggle tag on focused client.
    -- tag_keys[#tag_keys + 1] = awful.key({ env.modkey, "Control", "Shift" }, "#" .. i + 9, function()
    --     if client.focus then
    --         local tag = find_tag_by_name(name)
    --         if tag then
    --             client.focus:toggle_tag(tag)
    --         end
    --     end
    -- end, { description = "toggle focused client on tag #" .. name, group = "tag" })
end

return gears.table.join(table.unpack(tag_keys))
