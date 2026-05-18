#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle Ghostty Theme
# @raycast.mode silent
# @raycast.icon 🌓
# @raycast.packageName Ghostty

CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
DARK="Monokai Pro Machine"
LIGHT="Monokai Pro Light Sun"

current=$(grep -E '^theme = ' "$CONFIG" | head -1)

if echo "$current" | grep -q "^theme = $DARK$"; then
  next="theme = $LIGHT"
else
  next="theme = $DARK"
fi

# replace any existing `theme = ...` line (including multi-state dark:X,light:Y)
sed -i '' -E "s|^theme = .*|$next|" "$CONFIG"

# reload via Ghostty's default reload keybind (cmd+shift+,)
osascript -e 'tell application "System Events" to tell process "Ghostty" to keystroke "," using {command down, shift down}'
