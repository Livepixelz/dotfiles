#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

declare -A WS_ICONS=(
  [1]="󰅩"    # Code (Zed)
  [2]="󰆍"    # Terminal (Ghostty)
  [3]="󰖟"    # Web (Zen)
  [4]="󰙯"    # Discord
  [A]="󰧑"    # aNansi (AI)
  [C]="󰠴"    # Clutch (basketball)
  [M]="󰝚"    # Music
  [N]="󰠮"    # Notes
)

WORKSPACES=($(aerospace list-workspaces --all))
for ws in "${WORKSPACES[@]}"; do
  ICON="${WS_ICONS[$ws]:-$ws}"
  sketchybar --add item space.$ws left \
             --set space.$ws \
                icon="$ICON" \
                icon.font="$FONT:Bold:15.0" \
                icon.padding_left=10 \
                icon.padding_right=10 \
                label="$ws" \
                label.font="$FONT:Bold:11.0" \
                label.padding_right=10 \
                label.drawing=off \
                background.drawing=off \
                background.corner_radius=8 \
                background.height=24 \
                click_script="aerospace workspace $ws" \
                script="$PLUGIN_DIR/aerospace.sh $ws" \
             --subscribe space.$ws aerospace_workspace_change
done

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces background.color=$ITEM_BG_COLOR \
                        background.corner_radius=10 \
                        background.height=28
