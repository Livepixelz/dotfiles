#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.exited.global" ] || [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set appmenu popup.drawing=off
  exit 0
fi

PR_COUNT=$(gh search prs --review-requested=@me --state=open --json number --jq 'length' 2>/dev/null)
[ -z "$PR_COUNT" ] || [ "$PR_COUNT" = "null" ] && PR_COUNT="?"

if [ "$PR_COUNT" = "?" ]; then
  PR_LABEL="gh indisponible"
  PR_COLOR=$GREY
elif [ "$PR_COUNT" -eq 0 ]; then
  PR_LABEL="aucune PR à reviewer"
  PR_COLOR=$GREEN
else
  PR_LABEL="$PR_COUNT PR à reviewer"
  PR_COLOR=$ORANGE
fi

EVENT=$(osascript <<'EOF' 2>/dev/null
set output to ""
try
  tell application "Calendar"
    set now to current date
    set horizon to now + (24 * hours)
    set nextEvent to missing value
    set nextStart to missing value
    repeat with cal in calendars
      try
        set evs to (every event of cal whose start date ≥ now and start date ≤ horizon)
        repeat with ev in evs
          set s to start date of ev
          if nextStart is missing value or s < nextStart then
            set nextStart to s
            set nextEvent to summary of ev
          end if
        end repeat
      end try
    end repeat
    if nextEvent is not missing value then
      set h to (hours of nextStart) as string
      set m to text -2 thru -1 of ("0" & ((minutes of nextStart) as string))
      set output to h & ":" & m & " — " & nextEvent
    end if
  end tell
end try
return output
EOF
)

if [ -z "$EVENT" ]; then
  EVENT_LABEL="aucun event à venir"
  EVENT_COLOR=$GREY
else
  [ ${#EVENT} -gt 40 ] && EVENT="${EVENT:0:37}..."
  EVENT_LABEL="$EVENT"
  EVENT_COLOR=$WHITE
fi

BATT=$(pmset -g batt | grep -Eo '\d+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c "AC Power")
[ "$CHARGING" -gt 0 ] && BATT_ICON="" || BATT_ICON=""

DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_FREE=$((100 - DISK))

SYS_LABEL="$BATT_ICON $BATT%   $DISK_FREE% libre"
if [ "$BATT" -lt 20 ] || [ "$DISK_FREE" -lt 10 ]; then
  SYS_COLOR=$RED
elif [ "$BATT" -lt 40 ] || [ "$DISK_FREE" -lt 20 ]; then
  SYS_COLOR=$YELLOW
else
  SYS_COLOR=$WHITE
fi

sketchybar --set appmenu.prs label="$PR_LABEL" label.color=$PR_COLOR \
           --set appmenu.event label="$EVENT_LABEL" label.color=$EVENT_COLOR \
           --set appmenu.sys label="$SYS_LABEL" label.color=$SYS_COLOR
