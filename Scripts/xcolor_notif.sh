#!/bin/bash

COLOR=$(xcolor)
echo -n "$COLOR" | xclip -selection clipboard
notify-send --app-name "xcolor" "Color Picked" "$COLOR"
# --expire-time=2000
