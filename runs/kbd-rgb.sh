#!/bin/bash

KEY_CMD="sudo /usr/local/bin/set-kbd-color"
STEP=3
DELAY=0.005

set_color() {
  $KEY_CMD "$1" "$2" "$3"
}

hsv_to_rgb() {
  local h=$1 s=$2 v=$3
  local r g b

  h=$((h % 360))
  local hi=$((h / 60))
  local f_part=$((h % 60))

  local p=$((v * (100 - s) / 100))
  local q=$((v * (6000 - s * f_part) / 6000))
  local t=$((v * (6000 - s * (60 - f_part)) / 6000))

  case $hi in
    0) r=$v; g=$t; b=$p ;;
    1) r=$q; g=$v; b=$p ;;
    2) r=$p; g=$v; b=$t ;;
    3) r=$p; g=$q; b=$v ;;
    4) r=$t; g=$p; b=$v ;;
    5) r=$v; g=$p; b=$q ;;
  esac

  echo "$((r * 255 / 100)) $((g * 255 / 100)) $((b * 255 / 100))"
}

trap 'echo -e "\nStopping..."; exit 0' INT TERM

while true; do
  for ((h=0; h<360; h+=STEP)); do
    read r g b <<< "$(hsv_to_rgb $h 100 100)"
    set_color "$r" "$g" "$b"
    sleep "$DELAY"
  done
done
