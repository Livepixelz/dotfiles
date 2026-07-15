#!/usr/bin/env bash

# macOS réserve la bande du notch (safe area) : offset négatif pour coller au
# top, uniquement quand l'écran principal est le natif du MacBook.
if system_profiler SPDisplaysDataType 2>/dev/null | grep -A6 'Built-in' | grep -q 'Main Display: Yes'; then
  Y_OFFSET=-32
else
  Y_OFFSET=0
fi

sketchybar --bar \
  position=top \
  display=all \
  height=36 \
  margin=0 \
  y_offset=$Y_OFFSET \
  corner_radius=0 \
  notch_width=250 \
  blur_radius=20 \
  padding_left=8 \
  padding_right=8 \
  color=$BAR_COLOR \
  border_width=1 \
  border_color=0xff2a2a37 \
  shadow=on

default=(
  padding_left=4
  padding_right=4
  icon.font="$FONT:Bold:14.0"
  label.font="$FONT:Semibold:13.0"
  icon.color=$WHITE
  label.color=$WHITE
  icon.padding_left=8
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=8
  background.corner_radius=8
  background.height=24
  background.color=$TRANSPARENT
)
sketchybar --default "${default[@]}"
