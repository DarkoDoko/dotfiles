#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/plugins/app_icons.sh"

# icons of the apps that have windows in this workspace
apps=$(aerospace list-windows --workspace "$1" --format '%{app-name}' 2>/dev/null | sort -u)
icons=""
while IFS= read -r app; do
    icons="$icons$(icon_for "$app") "
done <<< "$apps"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on icon="$icons"
else
    sketchybar --set "$NAME" background.drawing=off icon="$icons"
fi
