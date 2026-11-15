#!/usr/bin/env bash

# Shows the title (and app icon) of the currently focused window.
# Subscribed to aerospace_workspace_change / aerospace_window_focus_change
# (triggered from aerospace.toml) and front_app_switched.

source "$CONFIG_DIR/plugins/app_icons.sh"

focused=$(aerospace list-windows --focused --format '%{app-name}|%{window-title}' 2>/dev/null)
app="${focused%%|*}"
title="${focused#*|}"

if [ -z "$focused" ]; then
    sketchybar --set "$NAME" icon="" label=""
else
    sketchybar --set "$NAME" icon="$(icon_for "$app")" label="$title"
fi
