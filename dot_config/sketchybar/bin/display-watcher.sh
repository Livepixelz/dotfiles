#!/usr/bin/env bash
# Watch display topology and restart sketchybar on change.
# Runs as a LaunchAgent — see ~/Library/LaunchAgents/com.livepixelz.sketchybar-display-watcher.plist
set -u

hash_displays() {
  /usr/sbin/system_profiler SPDisplaysDataType 2>/dev/null \
    | /usr/bin/grep -E "Resolution|Display Type|UI Looks like" \
    | /usr/bin/shasum | /usr/bin/awk '{print $1}'
}

prev="$(hash_displays)"
while true; do
  sleep 3
  cur="$(hash_displays)"
  if [ "$cur" != "$prev" ] && [ -n "$cur" ]; then
    sleep 2
    /opt/homebrew/bin/brew services restart sketchybar >/dev/null 2>&1
    prev="$(hash_displays)"
  fi
done
