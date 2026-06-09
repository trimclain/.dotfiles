local utils = require("utils")

local M = {}

-- stylua: ignore
local browser_candidates = {
    "thorium-browser",      -- my preferred browser
    "zen-browser",          -- my second preferred browser
    "brave-browser",        -- manual install on most systems
    "brave",                -- alternate Brave binary name
    "chromium",             -- common repo-provided browser
    "chromium-browser",     -- alternate distro/package binary name
    "firefox",              -- most likely real browser binary on mainstream desktop Linux
    "google-chrome-stable", -- common, but usually manually installed
    "google-chrome",        -- alternate Chrome binary name
    "qutebrowser",          -- power-user browser
    "vivaldi",              -- niche proprietary browser
    "opera",                -- uncommon preinstall
    "epiphany",             -- GNOME Web on GNOME-centric installs
    "konqueror",            -- KDE-associated, less common today
    "falkon",               -- Qt/KDE browser, sometimes present
    "librewolf",            -- niche privacy fork
    "waterfox",             -- niche Firefox-derived browser
    "tor-browser",          -- special-purpose browser
    "palemoon",             -- uncommon legacy-oriented browser
    "surf",                 -- very niche suckless browser
    "nyxt",                 -- very niche keyboard-driven browser
    "x-www-browser",        -- generic Debian alternatives entry; launchable if present, but not universal
}

-- INFO: for a variable to be accessible here it needs to be defined in /etc/environment
local _name = os.getenv("BROWSER") or ""

function M.get_name()
    return _name
end

if _name == "" then
    utils.find_first_executable(browser_candidates, function(cmd, _)
        if cmd then
            _name = cmd
        else
            utils.notify(
                "Crazy, but not a single web browser out of 22 options was found...",
                { preset = "critical", title = "Awesome Browser Error" }
            )
        end
    end)
end

return M
