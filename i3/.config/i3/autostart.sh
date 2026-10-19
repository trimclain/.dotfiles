#!/bin/bash

run_if_exists() {
    if command -v "$1" > /dev/null; then
        "$@"
    fi
}

# Set the wallpaper
#run_if_exists waypaper --backend feh --restore > /dev/null
run_if_exists ~/.fehbg

# System monitor for X11
run_if_exists conky --daemonize

# NetworkManager in system tray
#run_if_exists nm-applet &

# Enable transparency (done in ~/.xprofile)
#run_if_exists picom

# Set the delay and rate for keyboard auto-repeat (done in ~/.xprofile)
#xset r rate 400 25

# Enable multiple languages together with win-space toggle (done in ~/.xprofile)
# Use "localectl list-x11-keymap-options | grep grp:" to determine available keymap-options
# Use CAPS+"+a to compose letter ä, similarly for ö,ü,ß
#setxkbmap -layout us,ru -option grp:win_space_toggle,compose:caps

# Get the correct current brightness on system startup
#~/.local/bin/brightness-control --update-actual-brightness
