#!/usr/bin/env bash

# set correct current volume on system startup
if command -v pactl > /dev/null; then
    # FIX: value is empty on startup, so we need to wait a bit
    # Failed to get sink information: No such entity
    value=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | awk -F '%' '{ print $1 }')
    status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$status" = "no" ]; then
        output="墳 $value%"
    else
        output="婢 $value%"
    fi
    echo "$output" > ~/.actual_volume
fi
