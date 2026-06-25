#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if ! pgrep -x Discord >/dev/null 2>&1; then
  sketchybar --set discord drawing=off
  exit 0
fi

BADGE=$(osascript -e 'tell application "System Events" to tell process "Dock" to value of attribute "AXStatusLabel" of UI element "Discord" of list 1' 2>/dev/null)

if [ -z "$BADGE" ] || [ "$BADGE" = "missing value" ]; then
  sketchybar --set discord drawing=off
  exit 0
fi

sketchybar --set discord drawing=on icon="󰙯" icon.color=$PURPLE label="$BADGE"
