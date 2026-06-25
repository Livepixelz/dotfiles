#!/usr/bin/env bash

CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%d", s/'$(sysctl -n hw.logicalcpu)'}')
sketchybar --set "$NAME" label="${CPU}%"
