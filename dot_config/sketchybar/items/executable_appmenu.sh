#!/usr/bin/env bash

sketchybar --add item appmenu left \
           --set appmenu \
                icon.drawing=off \
                label.drawing=off \
                background.image="$CONFIG_DIR/icons/livepixelz.png" \
                background.image.scale=0.06 \
                background.color=$TRANSPARENT \
                background.height=36 \
                padding_left=12 \
                padding_right=8 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=off \
                popup.align=left \
                popup.y_offset=4 \
                update_freq=300 \
                script="$PLUGIN_DIR/appmenu.sh" \
                click_script="$PLUGIN_DIR/appmenu_click.sh" \
           --subscribe appmenu mouse.exited.global front_app_switched

popup_item() {
  local name=$1 icon=$2 color=$3 click=$4
  sketchybar --add item "$name" popup.appmenu \
             --set "$name" \
                  icon="$icon" \
                  icon.color=$color \
                  label="…" \
                  background.padding_left=8 \
                  background.padding_right=8 \
                  click_script="$click"
}

popup_item appmenu.prs   ""  $ORANGE "open 'https://github.com/pulls?q=is:open+is:pr+review-requested:@me' && sketchybar --set appmenu popup.drawing=off"
popup_item appmenu.event "󰸗" $BLUE   "open -a Calendar && sketchybar --set appmenu popup.drawing=off"
popup_item appmenu.sys   "" $WHITE  "sketchybar --set appmenu popup.drawing=off"
