#!/usr/bin/env bash

# Weather from wttr.in (IP-based location), cached for 30 min so the bar
# doesn't hammer the service. Click on the item opens wttr.in in the browser.

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

CACHE="$CONFIG_DIR/plugins/.weather_cache"

if [ -f "$CACHE" ] && [ $(( $(date +%s) - $(stat -f %m "$CACHE") )) -lt 1800 ]; then
    weather=$(cat "$CACHE")
else
    weather=$(curl -s --max-time 5 'wttr.in/?format=%c+%t' 2>/dev/null)
    if [ -n "$weather" ]; then
        echo "$weather" > "$CACHE"
    fi
fi

if [ -n "$weather" ]; then
    sketchybar --set "$NAME" label="$weather"
else
    sketchybar --set "$NAME" label="--"
fi
