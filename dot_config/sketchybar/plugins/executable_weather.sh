#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

DATA=$(curl -s --max-time 5 "wttr.in/?format=%c+%t" 2>/dev/null | tr -d '+')

if [ -z "$DATA" ] || [[ "$DATA" == *"Unknown"* ]]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon.drawing=off label="$DATA" label.color=$YELLOW
fi
