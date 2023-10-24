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
