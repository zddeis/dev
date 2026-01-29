#!/bin/bash

declare -A menu
brightness_levels=()

for i in {10..100..10}; do
    key="$i%"
    menu["$key"]="brightnessctl set ${i}%"
    brightness_levels+=("$i")
done

brightness_levels_sorted=($(printf "%s\n" "${brightness_levels[@]}" | sort -nr))

menu_keys=()
for i in "${brightness_levels_sorted[@]}"; do
    menu_keys+=("$i%")
done

option=$(printf "%s\n" "${menu_keys[@]}" | rofi -dmenu -i -p "Brightness" -i)

if [[ -n "$option" && -n "${menu[$option]}" ]]; then
    eval "${menu[$option]}"
fi
