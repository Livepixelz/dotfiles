#!/usr/bin/env bash
# Latence vers prod (premier server Hetzner trouvé via hcloud, sinon fallback).
# Cache le host pendant 1h pour éviter trop d'appels API.

CACHE=/tmp/sketchybar_prod_host
if [[ ! -f "$CACHE" ]] || (( $(date +%s) - $(stat -f %m "$CACHE" 2>/dev/null || echo 0) > 3600 )); then
  if command -v hcloud >/dev/null 2>&1; then
    hcloud server list -o json 2>/dev/null | /opt/homebrew/bin/jq -r '.[0].public_net.ipv4.ip // empty' > "$CACHE"
  fi
fi

HOST=$(cat "$CACHE" 2>/dev/null)
[[ -z "$HOST" ]] && { sketchybar --set "$NAME" drawing=off; exit 0; }

ms=$(ping -c 1 -W 1000 "$HOST" 2>/dev/null | grep -oE 'time=[0-9.]+' | cut -d= -f2)

if [[ -z "$ms" ]]; then
  sketchybar --set "$NAME" drawing=on icon="󰤭" icon.color=0xffe46876 label="prod down"
else
  ms_int=${ms%.*}
  if (( ms_int < 50 )); then color=0xff98bb6c
  elif (( ms_int < 150 )); then color=0xffe6c384
  else color=0xffe46876
  fi
  sketchybar --set "$NAME" drawing=on icon="󰓅" icon.color=$color label="${ms_int}ms"
fi
