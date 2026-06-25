#!/usr/bin/env bash
# Prochain événement Calendar via icalBuddy.
# Affiche : "  Standup · 14:30" ou rien si pas d'event aujourd'hui.

ICAL=/opt/homebrew/bin/icalBuddy

[[ ! -x "$ICAL" ]] && { sketchybar --set "$NAME" drawing=off; exit 0; }

event=$("$ICAL" \
  -nc -npn -eep notes,url,location,attendees \
  -df "" -tf "%H:%M" \
  -li 1 \
  eventsToday 2>/dev/null | head -1)

if [[ -z "$event" ]]; then
  sketchybar --set "$NAME" drawing=off
else
  title=$(echo "$event" | sed 's/ at [0-9].*//' | cut -c1-25)
  time=$(echo "$event" | grep -oE '[0-9]{2}:[0-9]{2}' | head -1)
  sketchybar --set "$NAME" \
    drawing=on \
    icon="" \
    icon.color=0xff7e9cd8 \
    label="$title · $time"
fi
