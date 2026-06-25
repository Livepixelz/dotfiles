#!/usr/bin/env bash

sketchybar --add item media center \
           --set media \
                update_freq=5 \
                icon.color=$PINK \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                click_script="$PLUGIN_DIR/media_click.sh" \
                script="$PLUGIN_DIR/media.sh" \
                drawing=off
