#!/bin/bash

# Take screenshot of selected area
filename="$HOME/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

if grim -g "$(slurp)" - | tee "$filename" | wl-copy; then
    notify-send -a "Screenshot" "Area captured" "Saved to Pictures and copied to clipboard" -i "$filename"
else
    notify-send -a "Screenshot" "Capture failed" "Could not capture screenshot" -u critical
fi
