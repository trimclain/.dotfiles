local lgi = require("lgi") -- GLib and Gio provide directory creation, permissions, and file streams

local Gio = lgi.Gio
local GLib = lgi.GLib

local M = {}

local state_home = os.getenv("XDG_STATE_HOME") or ""
if state_home:sub(1, 1) ~= "/" then
    state_home = (os.getenv("HOME") or GLib.get_home_dir()) .. "/.local/state"
end

local logdir = state_home .. "/awesome"
local logpath = logdir .. "/awesome.log"
local directory = Gio.File.new_for_path(logdir)
local logfile = Gio.File.new_for_path(logpath)
local max_size = 1024 * 1024 -- Keep one backup, awesome.log.1, when rotating at 1 MiB.
local initialized = false
local restart_separator_printed = false

local function report_error(err)
    initialized = false
    io.stderr:write("Awesome logger (" .. logpath .. "): " .. tostring(err) .. "\n")
end

local function initialize()
    if GLib.mkdir_with_parents(logdir, tonumber("700", 8)) ~= 0 then
        return report_error("could not create log directory")
    end

    local ok, err = directory:set_attribute_uint32("unix::mode", tonumber("700", 8), Gio.FileQueryInfoFlags.NONE)
    if not ok then
        return report_error(err)
    end

    local stream, open_err = logfile:append_to(Gio.FileCreateFlags.PRIVATE)
    if not stream then
        return report_error(open_err)
    end

    ok, err = logfile:set_attribute_uint32("unix::mode", tonumber("600", 8), Gio.FileQueryInfoFlags.NONE)
    local closed, close_err = stream:close()
    if not ok or not closed then
        return report_error(err or close_err)
    end

    initialized = true
    return true
end

local function open_log(entry_size)
    local stream, err = logfile:append_to(Gio.FileCreateFlags.PRIVATE)
    if not stream then
        return report_error(err)
    end

    local info, info_err = stream:query_info("standard::size")
    if not info then
        stream:close()
        return report_error(info_err)
    end

    -- Allow a single oversized entry rather than discarding or truncating it.
    local size = info:get_size()
    if size > 0 and size + entry_size > max_size then
        local closed, close_err = stream:close()
        if not closed then
            return report_error(close_err)
        end

        local renamed, rename_err = os.rename(logpath, logpath .. ".1")
        if not renamed then
            return report_error(rename_err)
        end

        stream, err = logfile:append_to(Gio.FileCreateFlags.PRIVATE)
        if not stream then
            return report_error(err)
        end
    end

    return stream
end

--- Log a message, initializing lazily and keeping one size-based backup.
---@param msg string
---@param level? string debug (default) | info | warn | error
function M.log(msg, level)
    if not initialized and not initialize() then
        return
    end

    level = level and string.upper(level) or "DEBUG"
    local entry = os.date("[%Y-%m-%d %H:%M:%S] ") .. level .. " " .. msg .. "\n"
    if not restart_separator_printed then
        entry = string.rep("—", 99) .. "\n" .. entry
    end

    local stream = open_log(#entry)
    if not stream then
        return
    end

    local written, write_err = stream:write_all(entry)
    local closed, close_err = stream:close()
    if not written or not closed then
        return report_error(write_err or close_err)
    end

    restart_separator_printed = true
end

return M
