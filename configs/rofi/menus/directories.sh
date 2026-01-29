#!/usr/bin/env bash

menu_directories=(
    "󰓓   Steam Common|$HOME/.local/share/Steam/steamapps/common"
    "   Downloads|$HOME/Downloads"
    "󰈙   Documents|$HOME/Documents"
    "   Custom Directory|__CUSTOM__"
)

menu_apps=(
    "󰪶   Nautilus|nautilus "
    "   Ghostty|ghostty --working-directory="
    "   VSCode|code "
    "   Nvim|ghostty -e nvim "
    "   Sudo Vim|ghostty -e sudo vim "
)

declare -A menu_map
menu_keys=()
for entry in "${menu_directories[@]}"; do
    key="${entry%%|*}"
    value="${entry#*|}"
    menu_keys+=("$key")
    menu_map["$key"]="$value"
done

dir=$(printf "%s\n" "${menu_keys[@]}" | rofi -dmenu -p "Directory:" -i)
if [[ -z "$dir" || -z "${menu_map[$dir]}" ]]; then
    exit 0
fi

if [[ "${menu_map[$dir]}" == "__CUSTOM__" ]]; then
    dir=$(rofi -dmenu -p "" -i)
    if [[ ! -d "$dir" ]]; then
        notify-send "Directory does not exist!" "$dir"
        exit 1
    fi
else
    dir="${menu_map[$dir]}"
fi

declare -A menu_map
menu_keys=()
for entry in "${menu_apps[@]}"; do
    key="${entry%%|*}"
    value="${entry#*|}"
    menu_keys+=("$key")
    menu_map["$key"]="$value"
done

app=$(printf "%s\n" "${menu_keys[@]}" | rofi -dmenu -p "App:" -i)
if [[ -z "$app" || -z "${menu_map[$app]}" ]]; then
    exit 0
fi
app="${menu_map[$app]}"

eval "$app\"$dir\""
