local utils = require("core.utils")

local M = {}

-- inpspired by i3-sensible-terminal, but with fixed sorting
-- stylua: ignore
local terminal_candidates = {
    "x-terminal-emulator", -- Debian-family generic terminal launcher; often present as an alternatives entry
    "xterm",               -- classic X11 fallback terminal; widely available on desktop Linux
    "gnome-terminal",      -- default terminal for GNOME, one of the most common desktop environments
    "konsole",             -- default terminal for KDE Plasma, another very common desktop environment
    "xfce4-terminal",      -- default terminal for Xfce, common on lightweight desktop installs
    "uxterm",              -- usually installed along with xterm as its UTF-8 wrapper
    "mate-terminal",       -- default terminal for MATE, common but less widespread than GNOME/KDE/Xfce
    "lxterminal",          -- standard terminal for LXDE, seen on lighter or older desktop installs
    "qterminal",           -- standard terminal for LXQt, moderately common on lightweight Qt desktops
    "terminator",          -- popular add-on terminal, but usually not preinstalled by default
    "tilix",               -- well-known tiling terminal, typically user-installed rather than default
    "guake",               -- popular drop-down terminal, usually an extra package
    "tilda",               -- another drop-down terminal, commonly available but not default
    "kitty",               -- popular with power users, but not commonly preinstalled
    "alacritty",           -- also popular with advanced users, usually installed manually
    "urxvt",               -- older minimalist favorite, less common on modern default installs
    "rxvt",                -- legacy terminal, mostly seen on older or niche setups
    "terminology",         -- mainly associated with Enlightenment, which is relatively uncommon
    "lilyterm",            -- niche GTK terminal, available in repos but rarely preinstalled
    "termit",              -- niche terminal, uncommon outside specific user preference
    "roxterm",             -- lesser-used VTE terminal, rarely the default choice
    "st",                  -- suckless terminal, mostly used in custom minimal setups
    "termite",             -- discontinued terminal, so unlikely on current random installs
    "hyper",               -- Electron-based terminal, almost always user-installed
    "wezterm",             -- modern and growing in popularity, but still usually manually installed
    "ghostty",             -- newer terminal, not yet common as a default distro install
    "rio",                 -- niche modern terminal, uncommon on mainstream distros
    "Eterm",               -- old Enlightenment-era terminal, rare on current systems
    "aterm",               -- older niche terminal, rarely present on modern installs
    "terminix",            -- old pre-rename Tilix name, unlikely on current systems
}

-- INFO: for a variable to be accessible here it needs to be defined in /etc/environment
local _name = os.getenv("TERMINAL") or ""
function M.get_name()
    --  apparently this is faster: https://ghostty.org/docs/linux/systemd#hyprland
    return _name == "ghostty" and "ghostty +new-window" or _name
end

if _name == "" then
    utils.find_first_executable(terminal_candidates, function(cmd, _)
        if cmd then
            _name = cmd
        else
            utils.notify(
                "Crazy, but not a single terminal emulator out of 30 options was found...",
                { preset = "critical", title = "Awesome Terminal Error" }
            )
        end
    end)
end

return M
