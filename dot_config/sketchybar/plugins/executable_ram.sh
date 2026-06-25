#!/usr/bin/env bash

PAGES=$(vm_stat | awk '/Pages free/ {f=$3} /Pages active/ {a=$3} /Pages inactive/ {i=$3} /Pages speculative/ {s=$3} /Pages wired/ {w=$4} /Pages occupied by compressor/ {c=$5} END {print a+w+c}')
PAGE_SIZE=$(pagesize)
TOTAL=$(sysctl -n hw.memsize)
USED=$((PAGES * PAGE_SIZE))
PCT=$((USED * 100 / TOTAL))

sketchybar --set "$NAME" label="${PCT}%"
