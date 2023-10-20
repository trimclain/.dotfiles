#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

activeMonitors=$(polybar -M | cut -d ':' -f 1)
monitors=()
for display in $activeMonitors; do
    monitors+=($display)
done
export MAIN_MONITOR=${monitors[0]}
export SECOND_MONITOR=${monitors[1]}

# define variables for automatic wlan/eth interface detection
export WLAN_INTERFACE
WLAN_INTERFACE=$(ip link | awk '/default/ {split($2, a, \":\"); print a[1]}' | grep wl)
export ETH_INTERFACE
ETH_INTERFACE=$(ip link | awk '/default/ {split($2, a, \":\"); print a[1]}' | grep en)

# Launch the correct bar depending on display dimensions
# Two 1920x1080 monitors
if [[ $(xdpyinfo | awk '/dimensions/{print $2}') == "3840x1080" ]]; then
    polybar --config="$HOME/.config/polybar/config.ini" mainbar 2>&1 | tee -a /tmp/polybar.log & disown
    if [[ -n $SECOND_MONITOR ]]; then
        polybar --config="$HOME/.config/polybar/config.ini" mainbar2 2>&1 | tee -a /tmp/polybar.log & disown
    fi

# SOMEDAY:
# xdpyinfo only gives the sum, so options : 3840 - 2 normals, 3286 -- one 1366 and one normal, normal, small

elif [[ $(xdpyinfo | awk '/dimensions/{print $2}') == "1366x768" ]]; then
    # Launch Polybar, using default config location ~/.config/polybar/config.ini
    # Since on ubuntu I have version 3.5.7, which doesn't default to config.ini yet, specify config variable
    polybar --config="$HOME/.config/polybar/config.ini" minibar 2>&1 | tee -a /tmp/polybar.log & disown
else
    polybar --config="$HOME/.config/polybar/config.ini" mainbar 2>&1 | tee -a /tmp/polybar.log & disown
fi
