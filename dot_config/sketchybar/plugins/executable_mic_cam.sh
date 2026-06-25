#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

CAM_ON=$(pgrep -f "VDCAssistant|AppleCameraAssistant|appleh13camerad" | wc -l | tr -d ' ')
MIC_ON=$(lsof -c coreaudiod 2>/dev/null | grep -ci "AppleHDAEngineInput\|VirtualAudio\|Microphone")

ICONS=""
if [ "$CAM_ON" -gt 0 ]; then
  ICONS=""
fi
if [ "$MIC_ON" -gt 0 ]; then
  ICONS="$ICONS "
fi

if [ -n "$ICONS" ]; then
  sketchybar --set "$NAME" drawing=on icon="$ICONS" icon.color=$RED label.drawing=off
else
  sketchybar --set "$NAME" drawing=off
fi
