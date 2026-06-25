#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

WS="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$WS" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color=$ACCENT_COLOR \
    icon.color=$BAR_COLOR \
    label.drawing=on \
    label.color=$BAR_COLOR
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color=$WHITE \
    label.drawing=off
fi
