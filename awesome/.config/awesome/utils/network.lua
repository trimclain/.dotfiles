--[[
System Requirements:
  - ip (iproute2)
  - optional: nmcli (networkmanager)
  - optional: nm-connection-editor
]]

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
local refresh_generation = 0
local nmcli_available = false

local show_less_info = false
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

--- Asynchronously get the IPv4 address for an interface
---@param iface string interface name
---@param callback fun(ip: string) function called with the IPv4 address
local function get_ipv4(iface, callback)
    local cmd = "ip -4 -brief addr show dev " .. utils.shell_quote(iface)
    utils.get_command_output(cmd, function(out, err, _)
        if err then
            gg("Error in network.get_ipv4(): " .. err)
            return
        end
        local ip = out:match("^%S+%s+%S+%s+([0-9.]+)") or ""
        callback(ip)
    end)
end

--- Asynchronously get the active Wi-Fi connection name.
--- Use the cached nmcli availability check; fall back to IPv4 on failure.
---@param iface string wireless interface name
---@param callback fun(name_or_ip: string) connection name or IPv4 address
local function get_wifi_ssid_or_ipv4(iface, callback)
    if not nmcli_available then
        get_ipv4(iface, callback)
        return
    end

    local cmd = "LC_ALL=C nmcli -t --escape no -g GENERAL.CONNECTION device show " .. utils.shell_quote(iface)

    utils.get_command_output(cmd, function(connection, err)
        if err then
            get_ipv4(iface, callback)
            return
        end

        callback(connection)
    end)
end

--- Toggle Wi-Fi through NetworkManager.
--- Report missing nmcli, unexpected state, or command failures.
local function toggle_wifi()
    utils.check_command_executable("nmcli", function(is_installed)
        if not is_installed then
            gg("Cannot toggle Wi-Fi: nmcli is not installed.")
            return
        end

        utils.get_command_output("LC_ALL=C nmcli radio wifi", function(status, err)
            if err then
                gg("Could not read Wi-Fi state: " .. err)
                return
            end

            local action

            if status == "enabled" then
                action = "off"
            elseif status == "disabled" then
                action = "on"
            else
                gg("Unexpected Wi-Fi state: " .. tostring(status))
                return
            end

            utils.get_command_output("LC_ALL=C nmcli radio wifi " .. action, function(_, toggle_error)
                if toggle_error then
                    gg("Could not toggle Wi-Fi: " .. toggle_error)
                end
            end)
        end)
    end)
end

--- Return whether the given network interface should be ignored.
--- Ignore loopback and some virtual interfaces we use.
---@param name string interface name
---@return boolean ignored true if the interface should be ignored, otherwise false
local function is_ignored_interface(name)
    return name == "lo"
        or name == "tailscale0" -- tailscale
        or name == "wt0" -- netbird
        or name:match("^virbr") ~= nil -- libvirt virtual bridges
        or name:match("^wg") ~= nil -- wireguard tunnels
end

--- Collect non-ignored network interfaces and stores them in priority order.
--- Populate `interfaces[name]` with interface metadata and fill
--- `ordered_interfaces` so wired or wireless interfaces come first
--- depending on `prioritize_wired`.
local function get_interfaces()
    interfaces = {}
    ordered_interfaces = {}

    local file, err = io.open("/proc/net/dev", "r")

    if not file then
        utils.log("Could not discover network interfaces: " .. tostring(err), "warn")
        return
    end

    local iface_list = {}

    -- populate the interface list, e.g. iface_list = { "enp2s0", "wlp4s0" }
    for line in file:lines() do
        local name = line:match("^%s*([^:]+):")

        if name and not is_ignored_interface(name) then
            iface_list[#iface_list + 1] = name
        end
    end

    file:close()

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

    refresh_generation = refresh_generation + 1
    local generation = refresh_generation

    if #ordered_interfaces == 0 then
        network_text:set_text(eth_icon .. "N/A")
        return
    end

    for _, name in ipairs(ordered_interfaces) do
        if has_carrier(name) then
            local iface = interfaces[name]

            if show_less_info then
                network_text:set_text(iface.wireless and wifi_icon or eth_icon)
                return
            end

            if iface.wireless then
                get_wifi_ssid_or_ipv4(name, function(ssid_or_ip)
                    if generation ~= refresh_generation then
                        return
                    end

                    network_text:set_text(wifi_icon .. ssid_or_ip)
                end)
            else
                get_ipv4(name, function(ip)
                    if generation ~= refresh_generation then
                        return
                    end

                    network_text:set_text(eth_icon .. ip)
                end)
            end
            return
        end
    end
    network_text:set_text(disconnected_icon)
end

--- Create and return the network widget, and start periodic refreshes (default: 1 sec).
---@param args? { timeout?: integer, compact?: boolean }
---@return any
function M.create_widget(args)
    assert(network_widget == nil, "network.create_widget() must only be called once")

    args = args or {}

    show_less_info = args.compact == true

    network_text = wibox.widget({
        text = disconnected_icon .. "--",
        widget = wibox.widget.textbox,
        buttons = gears.table.join(
            awful.button({}, 1, toggle_wifi),
            awful.button({}, 3, utils.launch("nm-connection-editor"))
        ),
    })

    network_widget = wibox.widget({
        {
            {
                network_text,
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            fg = beautiful.fg_network or beautiful.fg_normal,
            bg = beautiful.bg_network or beautiful.bg_normal,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        top = 4,
        bottom = 4,
        widget = wibox.container.margin,
    })

    -- Discover interfaces once; newly added adapters require restarting Awesome.
    get_interfaces()

    utils.check_command_executable("nmcli", function(is_installed)
        nmcli_available = is_installed
        refresh_widget()
    end)

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
