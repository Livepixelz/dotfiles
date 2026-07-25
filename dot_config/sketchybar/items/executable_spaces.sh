#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

# macOS ships bash 3.2 (no associative arrays) — use a case instead.
ws_icon() {
  case "$1" in
    1) echo "󰅩" ;;    # Code (Zed)
    2) echo "󰆍" ;;    # Terminal (Ghostty)
    3) echo "󰖟" ;;    # Web (Zen)
    4) echo "󰙯" ;;    # Discord
    M) echo "󰝚" ;;    # Music
    O) echo "󰀫" ;;    # Obsidian (notes)
    *) echo "$1" ;;
  esac
}

# Au boot, le serveur AeroSpace n'est pas toujours prêt → retry court,
# puis fallback sur la liste connue (les events recaleront le focus ensuite).
WORKSPACES=($(aerospace list-workspaces --all))
for _ in 1 2 3 4 5; do
  [ ${#WORKSPACES[@]} -gt 0 ] && break
  sleep 0.5
  WORKSPACES=($(aerospace list-workspaces --all))
done
[ ${#WORKSPACES[@]} -eq 0 ] && WORKSPACES=(1 2 3 4 M O)
for ws in "${WORKSPACES[@]}"; do
  ICON="$(ws_icon "$ws")"
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
                click_script="/opt/homebrew/bin/aerospace workspace $ws" \
                script="$PLUGIN_DIR/aerospace.sh $ws" \
             --subscribe space.$ws aerospace_workspace_change
done

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces background.color=$ITEM_BG_COLOR \
                        background.corner_radius=10 \
                        background.height=28
