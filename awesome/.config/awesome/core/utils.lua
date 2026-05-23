local M = {}

local awful = require("awful") -- Everything related to window managment
local naughty = require("naughty") -- Notification library

---@alias core.utils.PresetName
---| '"critical"'
---| '"info"'
---| '"low"'
---| '"normal"'
---| '"ok"'
---| '"warn"'

---@class core.utils.NotifyOpts
---@field preset? core.utils.PresetName Notification preset from naughty.config.presets; default: "info"
---@field title? string Notification title; default: "Debugging Awesome"
---@field timeout? integer Timeout in seconds, 0 means persistent; default: 0

--- Send a notification using naughty.notify
---@param msg string Notification text
---@param opts? core.utils.NotifyOpts Optional notification options
function M.notify(msg, opts)
    opts = opts or {}
    local preset = opts.preset and naughty.config.presets[opts.preset] or naughty.config.presets.info
    local title = opts.title or "Debugging Awesome"
    local timeout = opts.timeout or 0
    naughty.notify({
        preset = preset,
        title = title,
        text = msg,
        timeout = timeout,
    })
end

--- Get a human-readable representation of the given object
---@param value any
---@return string
function M.inspect(value)
    local seen = {}

    local function is_identifier(str)
        return type(str) == "string" and str:match("^[_%a][_%w]*$") ~= nil
    end

    local function is_array(tbl)
        local n = #tbl
        for k, _ in pairs(tbl) do
            if type(k) ~= "number" or k < 1 or k > n or k % 1 ~= 0 then
                return false
            end
        end
        return true
    end

    local function sorted_keys(tbl)
        local keys = {}
        for k in pairs(tbl) do
            keys[#keys + 1] = k
        end

        table.sort(keys, function(a, b)
            local ta, tb = type(a), type(b)

            if ta == tb then
                if ta == "number" or ta == "string" then
                    return a < b
                end
                return tostring(a) < tostring(b)
            end

            return ta < tb
        end)

        return keys
    end

    local function stringify(v, level)
        if type(v) == "string" then
            return string.format("%q", v)
        elseif type(v) ~= "table" then
            return tostring(v)
        elseif seen[v] then
            return "<circular>"
        end

        seen[v] = true

        if next(v) == nil then
            seen[v] = nil
            return "{}"
        end

        if is_array(v) then
            local parts = {}
            for i = 1, #v do
                parts[#parts + 1] = stringify(v[i], level + 1)
            end
            seen[v] = nil
            return "{ " .. table.concat(parts, ", ") .. " }"
        end

        local parts = {}
        local padding = string.rep("  ", level)
        local next_padding = string.rep("  ", level + 1)

        for _, k in ipairs(sorted_keys(v)) do
            local val = v[k]
            local key

            if is_identifier(k) then
                key = k
            else
                key = "[" .. stringify(k, 0) .. "]"
            end

            parts[#parts + 1] = next_padding .. key .. " = " .. stringify(val, level + 1)
        end

        seen[v] = nil
        return "{\n" .. table.concat(parts, ",\n") .. "\n" .. padding .. "}"
    end

    return stringify(value, 0)
end

--- Shell-quote a string so it can be safely embedded in a shell command
---@param s string
---@return string
local function shell_quote(s)
    return "'" .. s:gsub("'", [['"'"']]) .. "'"
end

local home = os.getenv("HOME") or "$HOME"

--- Check whether the executable from a command string exists in PATH
---@param cmd string
---@param callback fun(is_installed: boolean, executable: string, expanded_cmd: string)
function M.check_command_executable(cmd, callback)
    local expanded_cmd = cmd:gsub("~", home, 1)
    local executable = expanded_cmd:match("([^ ]+)")

    awful.spawn.easy_async_with_shell(
        "command -v -- " .. shell_quote(executable) .. " > /dev/null",
        function(_, _, _, exit_code)
            callback(exit_code == 0, executable, expanded_cmd)
        end
    )
end

--- Find the first executable command in a list
---@param tools string[]
---@param callback fun(found_cmd: string|nil, executable: string|nil)
function M.find_first_executable(tools, callback)
    local i = 1

    local function check_next()
        local tool = tools[i]

        if tool == nil then
            callback(nil, nil)
            return
        end

        M.check_command_executable(tool, function(is_installed, executable, expanded_cmd)
            if is_installed then
                callback(expanded_cmd, executable)
            else
                i = i + 1
                check_next()
            end
        end)
    end

    check_next()
end

--- Expand the command, validate that it's installed, and run it or show an error notification
---@param cmd string
function M.run_command(cmd)
    M.check_command_executable(cmd, function(is_installed, executable, expanded_cmd)
        if is_installed then
            awful.spawn(expanded_cmd)
            -- awful.spawn.with_shell(expanded_cmd)
        else
            M.notify("Executable '" .. executable .. "' not found.", { preset = "critical", title = "Command Error" })
        end
    end)
end

--- Run first command that is installed or show an error notification
---@param tools string[]
function M.run_first_available(tools)
    M.find_first_executable(tools, function(cmd, _)
        if cmd then
            awful.spawn(cmd)
            -- awful.spawn.with_shell(cmd)
        else
            M.notify(
                "None of these executables were found: " .. table.concat(tools, ", "),
                { preset = "critical", title = "Command Error" }
            )
        end
    end)
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
