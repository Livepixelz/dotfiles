#!/usr/bin/env bash

if [ "$SENDER" = "mouse.clicked" ] || [ -n "$PERCENTAGE" ]; then
  osascript -e "set volume output volume $PERCENTAGE"
fi
