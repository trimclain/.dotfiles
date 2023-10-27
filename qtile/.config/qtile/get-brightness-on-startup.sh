#!/usr/bin/env bash

# set correct current brightness on system startup
current=$(xrandr --verbose | awk '/Brightness/ { print $2; exit }')
output=$(awk "BEGIN {print $current*100}")
echo "$output%" > ~/.actual_brightness
