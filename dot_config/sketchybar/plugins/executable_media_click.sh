#!/usr/bin/env bash

case "$BUTTON" in
  left)  nowplaying-cli togglePlayPause ;;
  right) nowplaying-cli next ;;
  other) nowplaying-cli previous ;;
esac
sleep 0.2
"$HOME/.config/sketchybar/plugins/media.sh"
