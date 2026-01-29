#!/bin/bash

menu=(
    "   Lock|hyprlock"
    "   Reboot|systemctl reboot"
    "   Shutdown|systemctl poweroff"
    "   Exit Hyprland|hyprctl dispatch exit"
)

declare -A menu_map
menu_keys=()
for entry in "${menu[@]}"; do
    key="${entry%%|*}"
    value="${entry#*|}"
    menu_keys+=("$key")
    menu_map["$key"]="$value"
done

option=$(printf "%s\n" "${menu_keys[@]}" | rofi -dmenu -p "" -i)

if [[ -n "$option" && -n "${menu_map[$option]}" ]]; then
    eval "${menu_map[$option]}"
fi
