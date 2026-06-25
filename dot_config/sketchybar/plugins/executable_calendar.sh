#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

EVENT=$(icalBuddy -nc -npn -ea -eep "url,notes,location,attendees" -li 1 -b "" eventsToday 2>/dev/null | head -1 | sed 's/^ *//')

if [ -z "$EVENT" ]; then
  sketchybar --set "$NAME" drawing=off
else
  [ ${#EVENT} -gt 35 ] && EVENT="${EVENT:0:32}..."
  sketchybar --set "$NAME" drawing=on icon="" icon.color=$PURPLE label="$EVENT"
fi
