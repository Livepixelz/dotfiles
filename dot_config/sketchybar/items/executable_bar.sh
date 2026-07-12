#!/usr/bin/env bash

sketchybar --bar \
  position=top \
  display=all \
  height=36 \
  margin=8 \
  y_offset=6 \
  corner_radius=12 \
  notch_width=200 \
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
