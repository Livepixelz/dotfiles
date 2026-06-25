#!/usr/bin/env bash
# Score NBA — affiche un game live ou le prochain via nbacli.

NBA=/opt/homebrew/bin/nbacli
[[ ! -x "$NBA" ]] && { sketchybar --set "$NAME" drawing=off; exit 0; }

# Premier game live trouvé, sinon cache
result=$("$NBA" scoreboard 2>/dev/null | head -3)

if [[ -z "$result" ]]; then
  sketchybar --set "$NAME" drawing=off
else
  label=$(echo "$result" | grep -oE '[A-Z]{3}.*[0-9]+.*[A-Z]{3}.*[0-9]+' | head -1 | cut -c1-30)
  [[ -z "$label" ]] && label="NBA"
  sketchybar --set "$NAME" drawing=on icon="" icon.color=0xffffa066 label="$label"
fi
