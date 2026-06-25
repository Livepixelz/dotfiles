#!/usr/bin/env bash
# Cloudflare WARP — statut connexion.

WARP=/usr/local/bin/warp-cli
[[ ! -x "$WARP" ]] && WARP=/opt/homebrew/bin/warp-cli
[[ ! -x "$WARP" ]] && { sketchybar --set "$NAME" drawing=off; exit 0; }

status=$("$WARP" status 2>/dev/null | grep -oE "Status update: \K\w+")

case "$status" in
  Connected)
    sketchybar --set "$NAME" drawing=on icon="" icon.color=0xff98bb6c label=""
    ;;
  Connecting)
    sketchybar --set "$NAME" drawing=on icon="" icon.color=0xffe6c384 label=""
    ;;
  *)
    sketchybar --set "$NAME" drawing=on icon="" icon.color=0xffe46876 label=""
    ;;
esac
