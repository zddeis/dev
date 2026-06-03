#!/bin/bash

menu=(
    "   Projects|$HOME/dev/configs/rofi/menus/projects.sh"
    "   Directories|$HOME/dev/configs/rofi/menus/directories.sh"
    "   Opencode|ghostty -e zsh -lc '$HOME/.opencode/bin/opencode'"
    "   Settings|$HOME/dev/configs/rofi/menus/settings.sh"
    "   Stats|$HOME/dev/configs/rofi/menus/stats.sh"
    "   BTOP|ghostty -e btop"
    "⏻   Power|$HOME/dev/configs/rofi/menus/power.sh"
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
