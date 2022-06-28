#!/usr/bin/env bash

# get current brightness
if [ -f ~/.actual_brightness ]; then
    cat ~/.actual_brightness
else
    echo "N/A"
fi
