#!/usr/bin/env bash
# Pueue — affiche le nombre de jobs en cours.

PUEUE=/opt/homebrew/bin/pueue
[[ ! -x "$PUEUE" ]] && { sketchybar --set "$NAME" drawing=off; exit 0; }

running=$("$PUEUE" status --json 2>/dev/null | /opt/homebrew/bin/jq '[.tasks[] | select(.status == "Running" or .status.Running)] | length' 2>/dev/null)
queued=$("$PUEUE" status --json 2>/dev/null | /opt/homebrew/bin/jq '[.tasks[] | select(.status == "Queued")] | length' 2>/dev/null)
total=$(( ${running:-0} + ${queued:-0} ))

if (( total == 0 )); then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" \
    drawing=on \
    icon="" \
    icon.color=0xffe6c384 \
    label="$running running · $queued queued"
fi
