#!/usr/bin/env bash

# set correct current brightness on system startup
if command -v xrandr > /dev/null; then
    current=$(xrandr --verbose | awk '/Brightness/ { print $2; exit }')
    output=$(awk "BEGIN {print $current*100}")
    echo "$output%" > ~/.actual_brightness
fi
