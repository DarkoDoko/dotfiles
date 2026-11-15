#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=""
fi

# Time remaining (on battery) or until charged (on AC), e.g. "1:23 remaining"
TIME_LEFT="$(pmset -g batt | grep -Eo '[0-9]+:[0-9]+ remaining' | grep -Eo '^[0-9]+:[0-9]+')"
if [ -n "$TIME_LEFT" ] && ! pmset -g batt | grep -q 'charged;'; then
  h="${TIME_LEFT%%:*}"
  m="${TIME_LEFT#*:}"
  LABEL="${PERCENTAGE}% (${h}h$(printf '%02d' "$m")m)"
else
  LABEL="${PERCENTAGE}%"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
