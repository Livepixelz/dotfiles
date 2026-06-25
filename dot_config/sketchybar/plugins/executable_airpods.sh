#!/usr/bin/env bash
# AirPods battery via system_profiler.

bat=$(system_profiler SPBluetoothDataType -json 2>/dev/null \
  | /opt/homebrew/bin/jq -r '
      .SPBluetoothDataType[0].device_connected[]?
      | to_entries[]
      | select(.value.device_minorType == "Headphones" or (.key | test("AirPods"; "i")))
      | .value.device_batteryLevelMain // .value.device_batteryLevelLeft // empty
    ' 2>/dev/null | head -1)

bat="${bat//%/}"
if [[ -z "$bat" || ! "$bat" =~ ^[0-9]+$ ]]; then
  sketchybar --set "$NAME" drawing=off
else
  if   (( bat > 60 )); then color=0xff98bb6c
  elif (( bat > 25 )); then color=0xffe6c384
  else color=0xffe46876
  fi
  sketchybar --set "$NAME" drawing=on icon="" icon.color=$color label="${bat}%"
fi
