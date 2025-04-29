#!/bin/bash

run_in_background(){
    if command -v "$1" > /dev/null; then
        "$@" &
    fi
}

# Set the wallpaper
run_in_background nitrogen --restore
# Enable notifications
run_in_background dunst
# Network Manager
run_in_background nm-applet
# Get the correct current brightness on system startup
#~/.local/bin/brightness-control --update-actual-brightness

# Nextcloud for synchronization
#run_in_background nextcloud --background
