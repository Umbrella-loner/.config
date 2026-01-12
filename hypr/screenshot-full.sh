#!/bin/bash

# Take full screenshot
filename="$HOME/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

if grim - | tee "$filename" | wl-copy; then
    notify-send -a "Screenshot" "Screen captured" "Saved to Pictures and copied to clipboard" -i "$filename"
else
    notify-send -a "Screenshot" "Capture failed" "Could not capture screenshot" -u critical
fi
