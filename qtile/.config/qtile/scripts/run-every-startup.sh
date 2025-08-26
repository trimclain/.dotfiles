#!/bin/bash

run_in_background(){
    if command -v "$1" > /dev/null; then
        "$@" &
    fi
}

# Set the wallpaper
if [[ -z $WAYLAND_DISPLAY ]]; then
    run_in_background waypaper --backend feh --restore > /dev/null
fi

