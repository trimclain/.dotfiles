local awful = require("awful")
local beautiful = require("beautiful")
local fs = require("gears.filesystem")
local gears = require("gears")
local wibox = require("wibox")

local utils = require("utils")

local M = {}

local eth_icon = "󰣺 " -- "󰈀 "
local wifi_icon = "󰤨 " -- "󰖩 "
local disconnected_icon = "󰣼 " -- "󰤭 "

local network_text = nil
local network_widget = nil

local prioritize_wired = true
local interfaces = {}
local ordered_interfaces = {}

--- Send a critical notification
---@param msg string notification text
local function gg(msg)
    utils.notify(msg, { preset = "critical", title = "Awesome Network Error", timeout = 5 })
end

--- Return whether the given network interface currently has carrier
---@param iface string interface name, for example "enp2s0" or "wlp4s0"
---@return boolean connected true if the interface appears to be connected, otherwise false
local function has_carrier(iface)
    local carrier = utils.readline("/sys/class/net/" .. iface .. "/carrier") or ""
    if carrier == "1" then
        return true
    end
    local state = utils.readline("/sys/class/net/" .. iface .. "/operstate") or ""
    return state == "up"
end

--- Return whether the given network interface is wireless
---@param iface string interface name
---@return boolean state true if the interface is wireless, otherwise false
local function is_wireless(iface)
    return fs.is_dir("/sys/class/net/" .. iface .. "/wireless")
end

--- Asynchronously get the active Wi-Fi connection name for an interface
---@param iface string wireless interface name
---@param callback fun(ssid:string) function called with the SSID/connection name
local function get_wifi_ssid(iface, callback)
    local cmd = "LC_ALL=C nmcli -t -g GENERAL.CONNECTION device show " .. iface
    utils.get_command_output(cmd, function(ssid, err, _)
        if err then
            gg("Error in network.get_wifi_ssid(): " .. err)
            return
        end
        callback(ssid)
    end)
end

--- Asynchronously get the IPv4 address for an interface
---@param iface string interface name
---@param callback fun(ip:string) function called with the IPv4 address
local function get_ipv4(iface, callback)
    local cmd = "ip -4 -brief addr show dev " .. iface
    utils.get_command_output(cmd, function(out, err, _)
        if err then
            gg("Error in network.get_ipv4(): " .. err)
            return
        end
        local ip = out:match("^%S+%s+%S+%s+([0-9.]+)") or ""
        callback(ip)
    end)
end

--- Toggle the Wi-Fi on or off
local function toggle_wifi()
    utils.get_command_output("nmcli radio wifi", function(status, err, _)
        if err then
            gg("Error in network.toggle_wifi(): " .. err)
            return
        end
        if status == "enabled" then
            awful.spawn("nmcli radio wifi off")
        else
            awful.spawn("nmcli radio wifi on")
        end
    end)
end

--- Collect non-loopback network interfaces and stores them in priority order.
--- Populate `interfaces[name]` with interface metadata and fill
--- `ordered_interfaces` so wired or wireless interfaces come first
--- depending on `prioritize_wired`.
--- @return nil
local function get_interfaces()
    ordered_interfaces = {}

    -- populate the interface list, e.g. iface_list = { "enp2s0", "wlp4s0" }
    local iface_list = {}
    for _, line in ipairs(utils.readlines("/proc/net/dev", true)) do
        local name = line:match("^([^:]+):") or line:match("^%s*([^:]+):")
        if name and name ~= "lo" then
            iface_list[#iface_list + 1] = name
        end
    end

    -- populate the wired_interfaces and wireless_interfaces lists
    local wired_interfaces, wireless_interfaces = {}, {}
    for _, name in ipairs(iface_list) do
        local wireless_flag = is_wireless(name)
        interfaces[name] = { name = name, wireless = wireless_flag }

        if wireless_flag then
            wireless_interfaces[#wireless_interfaces + 1] = name
        else
            wired_interfaces[#wired_interfaces + 1] = name
        end
    end

    -- populate the interface_order table
    local first = prioritize_wired and wired_interfaces or wireless_interfaces
    local second = prioritize_wired and wireless_interfaces or wired_interfaces
    for _, name in ipairs(first) do
        ordered_interfaces[#ordered_interfaces + 1] = name
    end
    for _, name in ipairs(second) do
        ordered_interfaces[#ordered_interfaces + 1] = name
    end
end

local function refresh_widget()
    if not network_text then
        return
    end

    if #ordered_interfaces == 0 then
        network_text:set_text(eth_icon .. " N/A")
        return
    end

    for _, name in ipairs(ordered_interfaces) do
        if has_carrier(name) then
            local iface = interfaces[name]
            if iface.wireless then
                get_wifi_ssid(name, function(ssid)
                    network_text:set_text(wifi_icon .. " " .. ssid)
                end)
            else
                get_ipv4(name, function(ip)
                    network_text:set_text(eth_icon .. " " .. ip)
                end)
            end
            return
        end
    end
    network_text:set_text(disconnected_icon)
end

--- Create and return the RAM widget, and start periodic refreshes (default: 1 sec)
---@param args? { timeout?: integer }
---@return any
function M.create_widget(args)
    args = args or {}

    network_text = wibox.widget({
        text = disconnected_icon .. " --",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(
            awful.button({}, 1, toggle_wifi),
            awful.button({}, 3, utils.launch("nm-connection-editor"))
        ),
    })

    network_widget = wibox.widget({
        {
            network_text,
            -- left = 6,
            -- right = 6,
            -- top = 2,
            -- bottom = 2,
            widget = wibox.container.margin,
        },
        fg = beautiful.fg_network or beautiful.fg_normal,
        bg = beautiful.bg_network or beautiful.bg_normal,
        widget = wibox.container.background,
    })

    -- NOTE: I don't think I need to check every timeout if this changes, I don't even know how it would without reboot
    get_interfaces()

    gears.timer({
        timeout = args.timeout or 1,
        autostart = true,
        call_now = true,
        callback = function()
            refresh_widget()
        end,
    })

    return network_widget
end

return M
