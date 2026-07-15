#!/usr/bin/env bash

# Common pill style
pill_item() {
  local name=$1 position=$2; shift 2
  sketchybar --add item "$name" "$position" \
             --set "$name" \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                "$@"
}

right_item() { pill_item "$1" right "${@:2}"; }
left_item()  { pill_item "$1" left  "${@:2}"; }
