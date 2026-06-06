#!/usr/bin/env bash
# Toggle Claude AI keybinds on/off. State file = ~/.config/helix/.ai-disabled
flag="$HOME/.config/helix/.ai-disabled"
if [[ -f "$flag" ]]; then
  rm "$flag"
  echo "AI: ON"
else
  touch "$flag"
  echo "AI: OFF"
fi
