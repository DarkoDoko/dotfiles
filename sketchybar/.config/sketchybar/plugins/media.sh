#!/usr/bin/env bash

# Now playing for Apple Music (Music.app).
# Polled via update_freq on the item; hides itself when nothing is playing.
# Click on the bar item toggles play/pause (see click_script in sketchybarrc).

out=$(osascript -e '
tell application "Music"
    if player state is playing then
        set s to "playing"
    else if player state is paused then
        set s to "paused"
    else
        set s to "stopped"
    end if
    try
        set a to artist of current track
        set t to name of current track
    on error
        set a to ""
        set t to ""
    end try
    return s & "|" & a & "|" & t
end tell' 2>/dev/null)

state="${out%%|*}"
rest="${out#*|}"
artist="${rest%%|*}"
title="${rest#*|}"

case "$state" in
    playing) icon="" ;;
    paused)  icon="" ;;
    *)       sketchybar --set "$NAME" drawing=off; exit 0 ;;
esac

if [ -n "$artist" ]; then
    label="$artist - $title"
else
    label="$title"
fi

sketchybar --set "$NAME" drawing=on icon="$icon" label="$label"
