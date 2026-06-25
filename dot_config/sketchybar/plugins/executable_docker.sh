#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.exited.global" ] || [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set docker popup.drawing=off
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  sketchybar --set docker drawing=off
  exit 0
fi

COUNT=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')

if [ "$COUNT" -gt 0 ]; then
  sketchybar --set docker drawing=on icon="󰡨" icon.color=$BLUE label="$COUNT"
else
  sketchybar --set docker drawing=on icon="󰡨" icon.color=$GREY label="0"
fi

i=0
docker ps --format '{{.Names}} · {{.Status}}' 2>/dev/null | head -5 | while read -r line; do
  i=$((i+1))
  sketchybar --set docker.c$i drawing=on label="$line"
done
for j in $(seq $((COUNT+1)) 5); do
  sketchybar --set docker.c$j drawing=off 2>/dev/null
done
