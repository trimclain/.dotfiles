#!/usr/bin/env bash

# set correct current volume on system startup
if command -v pactl > /dev/null; then
    output=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | awk -F '%' '{ print $1 }')
    echo "$output%" > ~/.actual_volume
fi
