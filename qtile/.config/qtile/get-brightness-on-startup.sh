#!/usr/bin/env bash

# set correct current brightness on system startup
if command -v brightnessctl > /dev/null; then
    output=$(brightnessctl g -P)
elif [[ -z $WAYLAND_DISPLAY ]]; then
    # use xrandr if on xorg and no brightnessctl found
    current=$(xrandr --verbose | awk '/Brightness/ { print $2; exit }')
    output=$(awk "BEGIN {print $current*100}")
else
    # # use wlr-randr if on wayland and no brightnessctl found
    # current=$(wlr-randr | grep -oP '(?<=Brightness: )\d+(\.\d+)?')
    # output=$(awk "BEGIN {print $current*100}")
    notify-send "Brightness" "What the hell you doing on qtile on wayland? XDD"
fi

echo "$output%" > ~/.actual_brightness
