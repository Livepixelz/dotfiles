#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(gh search prs --state=open --author=@me --json number --jq 'length' 2>/dev/null)

if [ -z "$COUNT" ] || [ "$COUNT" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
elif [ "$COUNT" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on icon="󰊤" icon.color=$ORANGE label="$COUNT" label.drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
