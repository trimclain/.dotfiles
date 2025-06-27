--- @since 25.5.31
--- @sync entry

-- Credit: https://github.com/yazi-rs/plugins/blob/main/smart-enter.yazi

-- To open multiple selected files, add this to your `~/.config/yazi/init.lua`:
-- ```lua
-- require("smart-enter"):setup {
--     open_multi = true,
-- }
-- ```

local function setup(self, opts)
    self.open_multi = opts.open_multi
end

local function entry(self)
    local h = cx.active.current.hovered
    ya.emit(h and h.cha.is_dir and "enter" or "open", { hovered = not self.open_multi })
end

return { entry = entry, setup = setup }
