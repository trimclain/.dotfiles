#!/bin/bash

run_if_exists(){
    if command -v "$1" > /dev/null; then
        "$@"
    fi
}

# Set the wallpaper
#run_if_exists waypaper --backend feh --restore > /dev/null
run_if_exists $HOME/.fehbg

# System monitor for X11
run_if_exists conky --daemonize

# NetworkManager in system tray
#run_if_exists nm-applet &

# Enable transparency
#run_if_exists picom

# Get the correct current brightness on system startup
#~/.local/bin/brightness-control --update-actual-brightness

# Sets the delay and rate for keyboard auto-repeat
xset r rate 400 25

# Enable multiple languages together with win-space toggle
# Use "localectl list-x11-keymap-options | grep grp:" to determine available keymap-options
setxkbmap -layout us,ru
setxkbmap -option 'grp:win_space_toggle'
