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

# Set the delay and rate for keyboard auto-repeat (done in ~/.xprofile)
#xset r rate 400 25

# Disable DPMS and prevent screen from blanking (done in ~/.xprofile)
#xset s off -dpms

# US/Russian layouts, Win+Space to switch, Caps Lock as Compose (done in ~/.xprofile)
#setxkbmap -layout us,ru -option '' -option grp:win_space_toggle,compose:caps

# Enable transparency (done in ~/.xprofile)
#run_in_background picom

# NetworkManager in system tray
run_in_background nm-applet

# Polkit authentication agent for privileged GUI actions
run_in_background /usr/lib/polkit-kde-authentication-agent-1

# System monitor for X11
run_in_background conky --daemonize

# implements the XDG autostart specification (https://github.com/jceb/dex)
#dex --environment Awesome --autostart
]])
