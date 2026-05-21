local M = {}

local awful = require("awful") -- Everything related to window managment
local naughty = require("naughty") -- Notification library

--- Send info notification using naughty.notify
---@param msg string notification body
function M.inform(msg)
    naughty.notify({
        preset = naughty.config.presets.info,
        title = "Debugging Awesome",
        text = msg,
        timeout = 0,
    })
end

--- Shell-quote a string so it can be safely embedded in a shell command
---@param s string
---@return string
local function shell_quote(s)
    return "'" .. s:gsub("'", [['"'"']]) .. "'"
end

local home = os.getenv("HOME") or "$HOME"

--- Expand the command, validate that it's installed, and run it or show an error notification
---@param cmd string
function M.run_command(cmd)
    cmd = cmd:gsub("~", home, 1)
    local executable = cmd:match("([^ ]+)")

    awful.spawn.easy_async_with_shell(
        "command -v -- " .. shell_quote(executable) .. " > /dev/null",
        function(_, _, _, exit_code)
            if exit_code == 0 then
                awful.spawn.with_shell(cmd)
            else
                naughty.notify({
                    preset = naughty.config.presets.critical,
                    title = "Command Error",
                    text = "Executable '" .. executable .. "' not found.",
                })
            end
        end
    )
end

-- local function get_os_output(cmd, raw)
--     local f = assert(io.popen(cmd, "r"))
--     local s = assert(f:read("*a"))
--     f:close()
--     if raw then
--         return s
--     end
--     s = string.gsub(s, "^%s+", "")
--     s = string.gsub(s, "%s+$", "")
--     s = string.gsub(s, "[\n\r]+", " ")
--     return s
-- end
-- local operating_system = get_os_output("awk -F= '$1==\"ID\" { print $2 ;}' /etc/os-release")

return M
