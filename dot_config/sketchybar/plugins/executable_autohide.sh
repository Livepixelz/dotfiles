#!/usr/bin/env bash
# Auto-hide menubar style — affiche la bar quand la souris touche le haut de l'écran.
# Lancé en background par sketchybarrc.

HIDE_DELAY=0.6     # secondes avant de cacher après que la souris sort
SHOW_ZONE=4        # px depuis le haut qui déclenche l'apparition
HIDE_ZONE=60       # px sous le haut au-delà duquel on cache

last_state="hidden"
last_show=0

while true; do
  # cliclick p:. → "x,y" depuis le coin haut-gauche
  pos=$(/opt/homebrew/bin/cliclick p:. 2>/dev/null)
  y="${pos##*,}"

  if [[ "$y" =~ ^[0-9]+$ ]]; then
    if (( y <= SHOW_ZONE )); then
      if [[ "$last_state" != "shown" ]]; then
        sketchybar --bar hidden=off
        last_state="shown"
      fi
      last_show=$(date +%s)
    elif (( y > HIDE_ZONE )); then
      now=$(date +%s)
      if [[ "$last_state" == "shown" ]] && (( now - last_show > HIDE_DELAY )); then
        sketchybar --bar hidden=on
        last_state="hidden"
      fi
    fi
  fi
  sleep 0.15
done
