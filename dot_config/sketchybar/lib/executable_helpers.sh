#!/usr/bin/env bash

# Common pill style used across right-side items
right_item() {
  local name=$1; shift
  sketchybar --add item "$name" right \
             --set "$name" \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                "$@"
}
