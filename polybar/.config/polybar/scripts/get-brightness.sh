#!/usr/bin/env bash

# get current brightness
if [ -f /tmp/current_brightness ]; then
    cat /tmp/current_brightness
else
    echo "N/A"
fi
