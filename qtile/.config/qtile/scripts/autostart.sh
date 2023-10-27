#!/bin/bash

run_in_background(){
    if command -v "$1" > /dev/null; then
        "$@" &
    fi
}

# Network Manager
run_in_background nm-applet
# Set the wallpaper
run_in_background nitrogen --restore
# Get the correct current brightness and volume on system startup
~/.config/qtile/scripts/get-brightness-on-startup.sh
~/.config/qtile/scripts/get-volume-on-startup.sh
