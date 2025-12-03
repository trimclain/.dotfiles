#!/bin/bash

# Terminate already running bar instances
killall -q waybar

activeMonitors=$(hyprctl monitors | awk '$1 == "Monitor"{print $2}')
monitors=()
for display in $activeMonitors; do
    monitors+=("$display")
done
MAIN_MONITOR=${monitors[0]}
# SECOND_MONITOR=${monitors[1]}

resolutions=()
monitorResolutions=$(hyprctl monitors | awk -F@ '/ at / {print $1}')
for res in $monitorResolutions; do
    resolutions+=("$res")
done
MAIN_RES=${resolutions[0]}

WAYBAR_CONFIG=~/.config/waybar/config.jsonc
WAYBAR_STYLE=~/.config/waybar/style.css
TEMP_CONFIG=/tmp/waybar.jsonc
LOG_FILE=/tmp/waybar.log

if [[ "$MAIN_RES" == "1366x768" ]]; then
    # TODO: add output variables
    WAYBAR_CONFIG=~/.config/waybar/mini/config.jsonc
fi

# Primary Bar
MAIN_MONITOR=$MAIN_MONITOR envsubst < $WAYBAR_CONFIG > $TEMP_CONFIG; \
    waybar -c $TEMP_CONFIG -s $WAYBAR_STYLE 2>&1 \
    | tee -a $LOG_FILE & disown
