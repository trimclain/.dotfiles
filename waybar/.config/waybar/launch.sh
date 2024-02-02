#!/bin/bash

# TODO: finish this

# Terminate already running bar instances
killall -q waybar

activeMonitors=$(hyprctl monitors | awk '$1 == "Monitor"{print $2}')
monitors=()
for display in $activeMonitors; do
    monitors+=($display)
done
MAIN_MONITOR=${monitors[0]}
SECOND_MONITOR=${monitors[1]}

resolutions=()
monitorResolutions=$(hyprctl monitors | awk -F@ '/ at / {print $1}')
for res in $monitorResolutions; do
    resolutions+=($res)
done
MAIN_RES=${resolutions[0]}
SECOND_RES=${resolutions[1]}

# # define variables for automatic wlan/eth interface detection
# export WLAN_INTERFACE
# WLAN_INTERFACE=$(ip link | awk '/default/ {split($2, a, ":"); print a[1]}' | grep wl)
# export ETH_INTERFACE
# ETH_INTERFACE=$(ip link | awk '/default/ {split($2, a, ":"); print a[1]}' | grep en)

# TODO: multimonitor bar
# # Launch the correct bar depending on display dimensions
# # Two 1920x1080 monitors
# if [[ $(xdpyinfo | awk '/dimensions/{print $2}') == "3840x1080" ]]; then
#     polybar --config="$HOME/.config/polybar/config.ini" mainbar 2>&1 | tee -a /tmp/polybar.log & disown
#     if [[ -n $SECOND_MONITOR ]]; then
#         polybar --config="$HOME/.config/polybar/config.ini" mainbar2 2>&1 | tee -a /tmp/polybar.log & disown
#     fi

# # SOMEDAY:
# # xdpyinfo only gives the sum, so options : 3840 - 2 normals, 3286 -- one 1366 and one normal, normal, small

if [[ "$MAIN_RES" == "1366x768" ]]; then
    waybar -c "$HOME/.config/waybar/mini/config" \
        -s "$HOME/.config/waybar/mini/style.css" 2>&1 | tee -a /tmp/waybar.log & disown
else
    waybar 2>&1 | tee -a /tmp/waybar.log & disown
fi
