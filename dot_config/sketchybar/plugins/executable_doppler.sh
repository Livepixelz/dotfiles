#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

SCOPE="${DOPPLER_SCOPE:-$HOME/code/clutchdata}"

CONFIG=$(doppler configure get config --scope "$SCOPE" --plain 2>/dev/null)

if [ -z "$CONFIG" ]; then
  sketchybar --set doppler drawing=off
  exit 0
fi

case "$CONFIG" in
  dev*)     COLOR=$GREY;   SHORT="dev" ;;
  preview*|prv*) COLOR=$BLUE;   SHORT="prv" ;;
  stg*|staging*) COLOR=$YELLOW; SHORT="stg" ;;
  prd*|prod*)    COLOR=$RED;    SHORT="prd" ;;
  *)             COLOR=$WHITE;  SHORT="$CONFIG" ;;
esac

sketchybar --set doppler drawing=on \
                         icon="󰢬" \
                         icon.color=$COLOR \
                         label="$SHORT"
