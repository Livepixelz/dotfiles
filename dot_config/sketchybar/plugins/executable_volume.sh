#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "mouse.exited.global" ] || [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set volume popup.drawing=off
  exit 0
fi

if [ "$SENDER" = "volume_change" ] || [ "$SENDER" = "forced" ]; then
  VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾" ;;
    [3-5][0-9]) ICON="󰖀" ;;
    [1-9]|[1-2][0-9]) ICON="󰕿" ;;
    *) ICON="󰖁" ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" \
             --set volume.slider slider.percentage="$VOLUME"
fi
