#!/usr/bin/env bash

# get current volume
# if [ -f ~/.actual_volume ]; then
#     cat ~/.actual_volume
if [ -f ~/.local/bin/volume-control ]; then
    ~/.local/bin/volume-control --get-volume
else
    echo "N/A"
fi
