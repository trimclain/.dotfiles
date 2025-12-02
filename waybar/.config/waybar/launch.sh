#!/bin/bash

# TODO: finish this

# Terminate already running bar instances
killall -q waybar

activeMonitors=$(hyprctl monitors | awk '$1 == "Monitor"{print $2}')
monitors=()
for display in $activeMonitors; do
    monitors+=("$display")
done
MAIN_MONITOR=${monitors[0]}
SECOND_MONITOR=${monitors[1]}

resolutions=()
monitorResolutions=$(hyprctl monitors | awk -F@ '/ at / {print $1}')
for res in $monitorResolutions; do
    resolutions+=("$res")
done
MAIN_RES=${resolutions[0]}
SECOND_RES=${resolutions[1]}

if [[ "$MAIN_RES" == "1366x768" ]]; then
    # TODO: to launch waybar on specific monitor and use env variable:
    # exec_always "VARIABLE_FOR_WAYBAR=$mySwayVariable envsubst < ~/.config/waybar/config.jsonc > /tmp/waybar.jsonc; pkill waybar; exec waybar -c /tmp/waybar.jsonc"
    # and in waybar conf:
    # "output": "${VARIABLE_FOR_WAYBAR}",
    waybar -c "$HOME/.config/waybar/mini/config.jsonc" \
        -s "$HOME/.config/waybar/style.css" 2>&1 | tee -a /tmp/waybar.log & disown
else
    waybar 2>&1 | tee -a /tmp/waybar.log & disown
fi
