#!/usr/bin/env bash

sketchybar --add item media left \
           --set media \
                update_freq=5 \
                label.max_chars=20 \
                scroll_texts=on \
                icon.color=$PINK \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                click_script="$PLUGIN_DIR/media_click.sh" \
                script="$PLUGIN_DIR/media.sh" \
                drawing=off
