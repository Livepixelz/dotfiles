#!/usr/bin/env bash
# Pomodoro timer — clic pour start/pause, clic droit pour reset.
# État stocké dans /tmp/sketchybar_pomodoro

STATE_FILE="/tmp/sketchybar_pomodoro"
WORK_MIN=25
BREAK_MIN=5

read_state() {
  if [[ -f "$STATE_FILE" ]]; then
    cat "$STATE_FILE"
  else
    echo "idle 0 0 work"
  fi
}

write_state() { echo "$1 $2 $3 $4" > "$STATE_FILE"; }

read -r status start_ts duration_min phase <<< "$(read_state)"

case "$SENDER" in
  mouse.clicked)
    case "$BUTTON" in
      right) write_state "idle" 0 0 "work"; status="idle" ;;
      *)
        case "$status" in
          idle|done) write_state "running" "$(date +%s)" "$WORK_MIN" "work"; status="running"; phase="work"; duration_min=$WORK_MIN; start_ts=$(date +%s) ;;
          running) write_state "paused" "$start_ts" "$duration_min" "$phase"; status="paused" ;;
          paused) new_start=$(($(date +%s) - (duration_min*60 - $(cat "${STATE_FILE}.remain" 2>/dev/null || echo 0)) )); write_state "running" "$new_start" "$duration_min" "$phase"; status="running"; start_ts=$new_start ;;
        esac
        ;;
    esac
    ;;
esac

ICON=""
COLOR=0xff727169
LABEL=""

case "$status" in
  idle)
    LABEL="25:00"
    ;;
  running)
    elapsed=$(( $(date +%s) - start_ts ))
    remain=$(( duration_min * 60 - elapsed ))
    if (( remain <= 0 )); then
      osascript -e 'display notification "Pomodoro terminé" with title "🍅" sound name "Glass"'
      if [[ "$phase" == "work" ]]; then
        write_state "running" "$(date +%s)" "$BREAK_MIN" "break"
      else
        write_state "done" 0 0 "work"
      fi
      LABEL="00:00"
    else
      mins=$(( remain / 60 )); secs=$(( remain % 60 ))
      LABEL=$(printf "%02d:%02d" "$mins" "$secs")
    fi
    COLOR=$([ "$phase" = "work" ] && echo 0xffe46876 || echo 0xff98bb6c)
    echo $remain > "${STATE_FILE}.remain"
    ;;
  paused)
    LABEL="⏸ paused"
    COLOR=0xffe6c384
    ;;
  done)
    LABEL="✓ done"
    COLOR=0xff98bb6c
    ;;
esac

# Tick chaque seconde uniquement quand le timer tourne.
FREQ=$([ "$status" = "running" ] && echo 1 || echo 60)
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" update_freq="$FREQ"
