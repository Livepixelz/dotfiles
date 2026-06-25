#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.exited.global" ] || [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set gh_runs popup.drawing=off
  exit 0
fi

RUNS=$(gh run list --status in_progress --limit 5 --json workflowName,headBranch,name,databaseId 2>/dev/null)
COUNT=$(echo "$RUNS" | jq 'length' 2>/dev/null)

if [ -z "$COUNT" ] || [ "$COUNT" = "0" ]; then
  sketchybar --set gh_runs drawing=off
  for i in 1 2 3 4 5; do sketchybar --set gh_runs.r$i drawing=off 2>/dev/null; done
  exit 0
fi

sketchybar --set gh_runs drawing=on icon="󰑮" icon.color=$YELLOW label="$COUNT"

i=0
echo "$RUNS" | jq -r '.[] | "\(.workflowName) · \(.headBranch)"' | while read -r line; do
  i=$((i+1))
  sketchybar --set gh_runs.r$i drawing=on label="$line"
done
for j in $(seq $((COUNT+1)) 5); do
  sketchybar --set gh_runs.r$j drawing=off
done
