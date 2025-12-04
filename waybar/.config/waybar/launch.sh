#!/bin/bash

# Terminate already running bar instances
killall -q waybar

connectedOutputs=$(hyprctl monitors all | awk '$1 == "Monitor"{print $2}')
monitors=()
for display in $connectedOutputs; do
    monitors+=("$display")
done

resolutions=()
monitorResolutions=$(hyprctl monitors all | awk -F@ '/ at / {print $1}')
for res in $monitorResolutions; do
    resolutions+=("$res")
done

# External monitor is not always the first one
if [[ ${monitors[0]} == *HDMI* ]]; then
    INTERNAL=${monitors[1]}
    EXTERNAL=${monitors[0]}
    MAIN_RES=${resolutions[0]}
else
    INTERNAL=${monitors[0]}
    EXTERNAL=${monitors[1]}
    MAIN_RES=${resolutions[1]}
fi

# If no external monitor connected, fallback to internal
MAIN_MONITOR=$EXTERNAL
if [[ -z $MAIN_MONITOR ]]; then
    MAIN_MONITOR=$INTERNAL
    MAIN_RES=${resolutions[0]}
fi

WAYBAR_CONFIG=~/.config/waybar/config.jsonc
WAYBAR_STYLE=~/.config/waybar/style.css
TEMP_CONFIG=/tmp/waybar.jsonc
LOG_FILE=/tmp/waybar.log

if [[ "$MAIN_RES" == "1366x768" ]]; then
    WAYBAR_CONFIG=~/.config/waybar/mini/config.jsonc
fi

# Primary Bar
MAIN_MONITOR=$MAIN_MONITOR envsubst < $WAYBAR_CONFIG > $TEMP_CONFIG; \
    waybar -c $TEMP_CONFIG -s $WAYBAR_STYLE 2>&1 \
    | tee -a $LOG_FILE & disown
