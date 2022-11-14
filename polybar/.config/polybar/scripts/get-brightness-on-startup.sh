#!/usr/bin/env bash

# set correct current brightness on system startup
current=$(xrandr --verbose | awk '/Brightness/ { print $2; exit }')
output=$( echo $current*100/1 | bc )
echo $output% > ~/.actual_brightness
