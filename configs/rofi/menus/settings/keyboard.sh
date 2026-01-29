#!/bin/bash

declare -A COLORS=(
    ["Red"]="255 0 0"
    ["Green"]="0 255 0"
    ["Blue"]="0 0 255"
    ["Yellow"]="255 255 0"
    ["Cyan"]="0 255 255"
    ["Magenta"]="255 0 255"
    ["Purple"]="128 0 128"
    ["White"]="255 255 255"
    ["Off"]="0 0 0"
)

CHOICE=$(printf "%s\n" "${!COLORS[@]}" | sort | rofi -dmenu -p "" -i)

[ -z "$CHOICE" ] && exit 0

RGB="${COLORS[$CHOICE]}"

sudo /usr/local/bin/set-kbd-color $RGB
