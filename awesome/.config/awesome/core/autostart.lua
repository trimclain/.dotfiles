local awful = require("awful") -- Everything related to window managment

-- this works better for me than awful.spawn.once
awful.spawn.with_shell([[
if xrdb -query | grep -q '^awesome\.started:\s*true$'; then
    exit
fi
printf 'awesome.started:true\n' | xrdb -merge

run_in_background() {
    if command -v "$1" > /dev/null; then
        "$@" &
    fi
}

# Enable transparency (done in ~/.xprofile)
#run_in_background picom

# Get the correct current brightness on system startup
#~/.local/bin/brightness-control --update-actual-brightness

# NetworkManager in system tray
run_in_background nm-applet

# Authentication agent for GUI sudo popups
run_in_background /usr/lib/polkit-kde-authentication-agent-1

# System monitor for X11
run_in_background conky --daemonize

# implements the XDG autostart specification (https://github.com/jceb/dex)
#dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"

# Set the delay and rate for keyboard auto-repeat
xset r rate 400 25

# Enable multiple languages together with win-space toggle
# Use "localectl list-x11-keymap-options | grep grp:" to determine available keymap-options
# Use CAPS+"+a to compose letter ä, similarly for ö,ü,ß
setxkbmap -layout us,ru -option grp:win_space_toggle,compose:caps
]])
