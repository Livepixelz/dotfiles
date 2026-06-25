#!/usr/bin/env bash

sketchybar --add item front_app left \
           --set front_app \
                icon.drawing=off \
                label.font="$FONT:Bold:13.0" \
                label.color=$ACCENT_COLOR \
                script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
