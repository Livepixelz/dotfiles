#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

CAM_ON=$(lsof 2>/dev/null | grep -ciE "VDCAssistant|AppleCamera|appleh13camerad")
MIC_ON=$(lsof 2>/dev/null | grep -ciE "AudioCaptureProcess|coreaudiod.*Microphone")

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
