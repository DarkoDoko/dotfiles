#!/usr/bin/env bash

# $MODE is set directly as an env var by the
# `sketchybar --trigger aerospace_mode_change MODE=...` calls wired into
# aerospace.toml's mode.main/mode.service bindings.

if [ "$MODE" = "service" ]; then
  sketchybar --set "$NAME" drawing=on label="SERVICE MODE"
else
  sketchybar --set "$NAME" drawing=off
fi
