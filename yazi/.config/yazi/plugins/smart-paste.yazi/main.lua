--- @since 25.5.31
--- @sync entry

-- Description: Paste files into the hovered directory or to the CWD if hovering over a file.
-- Credit: https://github.com/yazi-rs/plugins/blob/main/smart-paste.yazi

return {
    entry = function()
        local h = cx.active.current.hovered
        if h and h.cha.is_dir then
            ya.emit("enter", {})
            ya.emit("paste", {})
            ya.emit("leave", {})
        else
            ya.emit("paste", {})
        end
    end,
}
