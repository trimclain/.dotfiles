#!/bin/bash

run_in_background(){
    if command -v "$1" > /dev/null; then
        "$@" &
    fi
}

# Set the wallpaper (NOTE: change if for some reason launching on Wayland)
run_in_background waypaper --backend feh --restore > /dev/null
# Enable notifications
run_in_background dunst
# Network Manager
run_in_background nm-applet
# Get the correct current brightness on system startup
#~/.local/bin/brightness-control --update-actual-brightness

# Authentication agent for GUI sudo popups
run_in_background /usr/lib/polkit-kde-authentication-agent-1

# Nextcloud for synchronization
#run_in_background nextcloud --background
