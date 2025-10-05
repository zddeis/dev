#!/bin/bash

# Menu options
options="📦 Apps\n🖥 Window\n😃 Emojis\n🔢 Calculator"

# Show menu
chosen=$(printf "$options" | rofi -dmenu -i -p "Menu" -theme-str)

# Handle selection
case "$chosen" in
    "📦 Apps") rofi -show drun -show-icons ;;
    "🖥 Window") rofi -show window ;;
    "😃 Emojis") rofi -show emoji -emoji-format '{emoji} <span weight="bold">{name}</span>' ;;
    "🔢 Calculator") rofi -show calc -no-show-match -no-sort -no-history -lines 0;;
    *) exit 1 ;;
esac