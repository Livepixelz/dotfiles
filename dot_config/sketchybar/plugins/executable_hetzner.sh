#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

probe() {
  local host=$1
  ssh -o ConnectTimeout=3 -o BatchMode=yes "$host" "uptime" 2>/dev/null
}

V1=$(probe vps1)
V2=$(probe vps2)

parse_load() {
  echo "$1" | awk -F'load average[s]*: ' '{print $2}' | awk -F',' '{print $1}' | tr -d ' '
}
parse_up() {
  echo "$1" | awk -F'up ' '{print $2}' | awk -F',  *[0-9]+ user' '{print $1}'
}

L1=$(parse_load "$V1"); L2=$(parse_load "$V2")
U1=$(parse_up "$V1"); U2=$(parse_up "$V2")

worst=$(echo -e "${L1:-99}\n${L2:-99}" | sort -g | tail -1)
if [ -z "$V1" ] || [ -z "$V2" ]; then
  COLOR=$RED; DOT=""
elif awk -v l="$worst" 'BEGIN{exit !(l>4)}'; then
  COLOR=$ORANGE; DOT=""
else
  COLOR=$GREEN; DOT=""
fi

sketchybar --set hetzner icon="$DOT" icon.color=$COLOR label=""

[ -n "$V1" ] && sketchybar --set hetzner.vps1 label="vps1 — load $L1 · up $U1" || sketchybar --set hetzner.vps1 label="vps1 — down" label.color=$RED
[ -n "$V2" ] && sketchybar --set hetzner.vps2 label="vps2 — load $L2 · up $U2" || sketchybar --set hetzner.vps2 label="vps2 — down" label.color=$RED
