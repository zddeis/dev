#!/bin/bash

declare -A menu=(
    ["󰃟   Keyboard"]="$HOME/dev/configs/rofi/menus/settings/keyboard.sh"
    ["󰃟   Brightness"]="$HOME/dev/configs/rofi/menus/settings/brightness.sh"
)

option=$(printf "%s\n" "${!menu[@]}" | rofi -dmenu -p "Settings" -i)

if [[ -n "$option" && -n "${menu[$option]}" ]]; then
    eval "${menu[$option]}"
fi
