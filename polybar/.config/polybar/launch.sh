#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# define variables for automatic wlan/eth interface detection
export WLAN_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep wl)
export ETH_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep en)

# Launch the correct bar depending on display dimensions
if [[ $(xdpyinfo | awk '/dimensions/{print $2}') == "1920x1080" ]]; then
    # Launch Polybar, using default config location ~/.config/polybar/config.ini
    polybar mainbar 2>&1 | tee -a /tmp/polybar.log & disown
else
    polybar minibar 2>&1 | tee -a /tmp/polybar.log & disown
fi
