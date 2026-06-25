#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color=$ACCENT_COLOR \
    icon.color=$BAR_COLOR
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color=$WHITE
fi
