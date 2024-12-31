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
# Enable notifications
run_in_background dunst
# Get the correct current brightness on system startup
#~/.config/qtile/scripts/get-brightness-on-startup.sh

# Pull my repos
# TODO: this doesn't work since the variable $PROJECTLIST is missing
#run_in_background ~/.local/bin/pctl pull

# Nextcloud for synchronization
#run_in_background nextcloud --background
