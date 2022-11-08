#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# define variables for automatic wlan/eth interface detection
export WLAN_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep wl)
export ETH_INTERFACE=$(ip link | grep default | awk '{print $2}' | awk -F ':' '{print $1}' | grep en)

# TODO: have another bar for 1366x728 display
# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar mainbar 2>&1 | tee -a /tmp/polybar.log & disown
