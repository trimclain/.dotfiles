#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# define variables for automatic wlan/eth interface detection
export WLAN_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep wl)
export ETH_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep en)

# Launch the correct bar depending on display dimensions
if [[ $(xdpyinfo | awk '/dimensions/{print $2}') == "1366x768" ]]; then
    # Launch Polybar, using default config location ~/.config/polybar/config.ini
    # Since on ubuntu I have version 3.5.7, which doesn't default to config.ini yet, specify config variable
    polybar --config=$HOME/.config/polybar/config.ini minibar 2>&1 | tee -a /tmp/polybar.log & disown
else
    polybar --config=$HOME/.config/polybar/config.ini mainbar 2>&1 | tee -a /tmp/polybar.log & disown
fi
