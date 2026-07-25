#!/usr/bin/env bash

# Note: items are added right-to-left visually — last added = leftmost on the right side.

right_item mic_cam \
  update_freq=3 \
  script="$PLUGIN_DIR/mic_cam.sh" \
  drawing=off

right_item clock \
  update_freq=10 \
  icon="󰥔" \
  icon.color=$PINK \
  script="$PLUGIN_DIR/clock.sh"

sketchybar --add item battery right \
           --set battery \
                update_freq=120 \
                icon.color=$GREEN \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change

sketchybar --add item volume right \
           --set volume \
                icon.color=$BLUE \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=on \
                popup.align=center \
                popup.y_offset=4 \
                script="$PLUGIN_DIR/volume.sh" \
                click_script="$PLUGIN_DIR/volume_click.sh" \
           --subscribe volume volume_change mouse.exited.global front_app_switched

sketchybar --add slider volume.slider popup.volume 120 \
           --set volume.slider \
                slider.highlight_color=$BLUE \
                slider.background.height=6 \
                slider.background.corner_radius=3 \
                slider.background.color=0xff3a3a47 \
                slider.knob="" \
                slider.knob.drawing=on \
                background.padding_left=10 \
                background.padding_right=10 \
                background.height=28 \
                script="$PLUGIN_DIR/volume_slider.sh"

right_item cpu \
  update_freq=5 \
  icon="󰻠" \
  icon.color=$ORANGE \
  script="$PLUGIN_DIR/cpu.sh"

right_item ram \
  update_freq=10 \
  icon="󰘚" \
  icon.color=$PURPLE \
  script="$PLUGIN_DIR/ram.sh"

right_item wifi \
  update_freq=30 \
  script="$PLUGIN_DIR/wifi.sh"

right_item doppler \
  update_freq=30 \
  click_script="open https://dashboard.doppler.com" \
  script="$PLUGIN_DIR/doppler.sh"

right_item github \
  update_freq=300 \
  click_script="open https://github.com/pulls" \
  script="$PLUGIN_DIR/github.sh"

sketchybar --add item claude right \
           --set claude \
                update_freq=120 \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=off \
                popup.align=right \
                popup.y_offset=4 \
                click_script="sketchybar --set claude popup.drawing=toggle" \
                script="$PLUGIN_DIR/claude.sh" \
           --subscribe claude mouse.exited.global front_app_switched

for row in session weekly opus; do
  sketchybar --add item claude.$row popup.claude \
             --set claude.$row background.padding_left=8 background.padding_right=8
done

sketchybar --add item claude.link popup.claude \
           --set claude.link \
                icon="󰖟" \
                icon.color=$BLUE \
                label="Ouvrir la page usage" \
                background.padding_left=8 \
                background.padding_right=8 \
                click_script="open https://claude.ai/settings/usage && sketchybar --set claude popup.drawing=off"

sketchybar --add item docker right \
           --set docker \
                update_freq=30 \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=off \
                popup.align=right \
                popup.y_offset=4 \
                click_script="sketchybar --set docker popup.drawing=toggle" \
                script="$PLUGIN_DIR/docker.sh" \
           --subscribe docker mouse.exited.global front_app_switched

for i in 1 2 3 4 5; do
  sketchybar --add item docker.c$i popup.docker \
             --set docker.c$i drawing=off background.padding_left=8 background.padding_right=8
done

sketchybar --add item deploy right \
           --set deploy \
                update_freq=300 \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                click_script="open https://github.com/livepixelz-corp/clutchdata/actions/workflows" \
                script="$PLUGIN_DIR/deploy.sh"

sketchybar --add item gh_runs right \
           --set gh_runs \
                update_freq=120 \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=off \
                popup.align=right \
                popup.y_offset=4 \
                click_script="sketchybar --set gh_runs popup.drawing=toggle" \
                script="$PLUGIN_DIR/gh_runs.sh" \
           --subscribe gh_runs mouse.exited.global front_app_switched

for i in 1 2 3 4 5; do
  sketchybar --add item gh_runs.r$i popup.gh_runs \
             --set gh_runs.r$i drawing=off background.padding_left=8 background.padding_right=8
done

sketchybar --add item hetzner right \
           --set hetzner \
                update_freq=120 \
                background.color=$ITEM_BG_COLOR \
                background.height=28 \
                background.corner_radius=10 \
                popup.background.color=$ITEM_BG_COLOR \
                popup.background.corner_radius=10 \
                popup.background.border_width=1 \
                popup.background.border_color=0xff3a3a47 \
                popup.horizontal=off \
                popup.align=right \
                popup.y_offset=4 \
                click_script="sketchybar --set hetzner popup.drawing=toggle" \
                script="$PLUGIN_DIR/hetzner.sh" \
           --subscribe hetzner mouse.exited.global front_app_switched

for vps in vps1 vps2; do
  sketchybar --add item hetzner.$vps popup.hetzner \
             --set hetzner.$vps \
                  background.padding_left=8 \
                  background.padding_right=8 \
                  label="$vps — …" \
                  click_script="open 'https://monitor.clutch-data.com/system/$vps' && sketchybar --set hetzner popup.drawing=off"
done

right_item discord \
  update_freq=20 \
  click_script="open -a Discord" \
  script="$PLUGIN_DIR/discord.sh"

right_item calendar \
  update_freq=300 \
  click_script="open -a Calendar" \
  script="$PLUGIN_DIR/calendar.sh"

left_item weather \
  update_freq=900 \
  script="$PLUGIN_DIR/weather.sh"

# --- New items ---

# À gauche : la zone droite est trop chargée et déborderait sous le notch.
left_item pomodoro \
  update_freq=1 \
  click_script="$PLUGIN_DIR/pomodoro.sh" \
  script="$PLUGIN_DIR/pomodoro.sh"
sketchybar --subscribe pomodoro mouse.clicked

right_item next_event \
  update_freq=120 \
  click_script="open -a Calendar" \
  script="$PLUGIN_DIR/next_event.sh"

right_item pueue \
  update_freq=5 \
  click_script="open -a Ghostty" \
  script="$PLUGIN_DIR/pueue.sh"

right_item warp \
  update_freq=30 \
  click_script="open -a 'Cloudflare WARP'" \
  script="$PLUGIN_DIR/warp.sh"

right_item ping_prod \
  update_freq=30 \
  click_script="open https://console.hetzner.cloud" \
  script="$PLUGIN_DIR/ping_prod.sh"

right_item nba \
  update_freq=180 \
  click_script="open https://www.nba.com/scores" \
  script="$PLUGIN_DIR/nba.sh"

right_item airpods \
  update_freq=60 \
  script="$PLUGIN_DIR/airpods.sh"
