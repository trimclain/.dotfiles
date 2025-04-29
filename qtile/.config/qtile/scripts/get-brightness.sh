#!/usr/bin/env bash

# get current brightness
if [ -f ~/.local/bin/brightness-control ]; then
    ~/.local/bin/brightness-control --get-brightness
else
    echo "N/A"
fi
