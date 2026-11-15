#!/usr/bin/env bash

# App-name -> glyph mapping for sketchybar-app-font (~/Library/Fonts/sketchybar-app-font.ttf).
# Glyphs are private-use-area characters extracted from the font cmap (:name: glyphs).

icon_for() {
  case "$1" in
    "Ghostty") echo "" ;;
    "iTerm2") echo "" ;;
    "Terminal") echo "" ;;
    "WezTerm") echo "" ;;
    "Alacritty") echo "" ;;
    "Supacode") echo "" ;;
    "Firefox") echo "" ;;
    "Brave Browser") echo "" ;;
    "Safari") echo "" ;;
    "Google Chrome") echo "" ;;
    "Arc") echo "" ;;
    "Sublime Text") echo "" ;;
    "Code") echo "" ;;
    "IntelliJ IDEA") echo "" ;;
    "Xcode") echo "" ;;
    "Fork") echo "" ;;
    "Docker Desktop") echo "" ;;
    "Calendar") echo "" ;;
    "Slack") echo "" ;;
    "Microsoft Teams") echo "" ;;
    "Mail") echo "" ;;
    "Luki") echo "" ;;
    "Music") echo "" ;;
    "Claude") echo "" ;;
    "Finder") echo "" ;;
    "System Settings") echo "" ;;
    "Notes") echo "" ;;
    "Obsidian") echo "" ;;
    "Notion") echo "" ;;
    "Discord") echo "" ;;
    "Spotify") echo "" ;;
    "App Store") echo "" ;;
    "WhatsApp") echo "" ;;
    "Zoom") echo "" ;;
    "Passwords") echo "" ;;
    "Activity Monitor") echo "" ;;
    "Preview") echo "" ;;
    "Maps") echo "" ;;
    "Photos") echo "" ;;
    "Reminders") echo "" ;;
    "Freeform") echo "" ;;
    "TextEdit") echo "" ;;
    *) echo "" ;;
  esac
}
