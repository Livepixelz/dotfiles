#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

RUN=$(gh run list --repo livepixelz-corp/clutchdata --workflow "Build & Deploy" --limit 1 \
        --json status,conclusion,headSha,createdAt,displayTitle 2>/dev/null | jq '.[0]')

if [ -z "$RUN" ] || [ "$RUN" = "null" ]; then
  sketchybar --set deploy drawing=off
  exit 0
fi

STATUS=$(echo "$RUN" | jq -r '.status')
CONCLUSION=$(echo "$RUN" | jq -r '.conclusion')
SHA=$(echo "$RUN" | jq -r '.headSha' | cut -c1-7)
WHEN=$(echo "$RUN" | jq -r '.createdAt')
AGO=$(( ($(date +%s) - $(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$WHEN" +%s 2>/dev/null)) / 60 ))

if [ "$AGO" -lt 60 ]; then
  WHEN_LABEL="${AGO}m"
elif [ "$AGO" -lt 1440 ]; then
  WHEN_LABEL="$((AGO/60))h"
else
  WHEN_LABEL="$((AGO/1440))d"
fi

case "$STATUS" in
  in_progress|queued|waiting) ICON="󰑮"; COLOR=$YELLOW ;;
  completed)
    case "$CONCLUSION" in
      success) ICON="󰗠"; COLOR=$GREEN ;;
      failure) ICON="󰅖"; COLOR=$RED ;;
      cancelled) ICON="󰜺"; COLOR=$GREY ;;
      *) ICON="󰋗"; COLOR=$GREY ;;
    esac ;;
  *) ICON="󰋗"; COLOR=$GREY ;;
esac

sketchybar --set deploy drawing=on icon="$ICON" icon.color=$COLOR label="$SHA · ${WHEN_LABEL}"
