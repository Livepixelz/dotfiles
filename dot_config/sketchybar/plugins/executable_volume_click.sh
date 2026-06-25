#!/usr/bin/env bash

if [ "$BUTTON" = "right" ]; then
  MUTED=$(osascript -e 'output muted of (get volume settings)')
  if [ "$MUTED" = "true" ]; then
    osascript -e 'set volume output muted false'
  else
    osascript -e 'set volume output muted true'
  fi
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
  MUTED=$(osascript -e 'output muted of (get volume settings)')
  if [ "$MUTED" = "true" ]; then
    sketchybar --set volume icon="󰖁" label="muted"
  else
    sketchybar --trigger volume_change INFO="$VOLUME"
  fi
else
  sketchybar --set volume popup.drawing=toggle
fi
