#!/usr/bin/env bash

# get current volume
if [ -f ~/.actual_volume ]; then
    cat ~/.actual_volume
else
    echo "N/A"
fi
