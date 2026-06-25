#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

RAW=$(osascript -e 'tell application "Music" to if it is running then return (player state as string) & "|" & (name of current track) & "|" & (artist of current track)' 2>/dev/null)

if [ -z "$RAW" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

STATE="${RAW%%|*}"
REST="${RAW#*|}"
TITLE="${REST%%|*}"
ARTIST="${REST#*|}"

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$STATE" = "playing" ]; then
  ICON=""
else
  ICON=""
fi

LABEL="$ARTIST — $TITLE"
if [ ${#LABEL} -gt 40 ]; then
  LABEL="${LABEL:0:37}..."
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=$PINK label="$LABEL"
