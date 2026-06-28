#!/bin/bash

# List of files and their target destinations
# Format: "source_file:destination_file"
FILES=( 
  "$HOME/dev/configs/discord/Acrilic.css:$HOME/.config/Vencord/themes/Acrilic.css"
  "$HOME/dev/configs/discord/sys24.css:$HOME/.config/Vencord/themes/sys24.css"
  "$HOME/dev/configs/discord/custom_mica.css:$HOME/.config/Vencord/themes/custom_mica.css"
  "$HOME/dev/configs/discord/mica.css:$HOME/.config/Vencord/themes/mica.css"

  "$HOME/dev/configs/hyprland/hyprland.lua:$HOME/.config/hypr/hyprland.lua"
  "$HOME/dev/configs/hyprland/modules:$HOME/.config/hypr/"
  "$HOME/dev/configs/hyprland/hyprpaper.conf:$HOME/.config/hypr/hyprpaper.conf"
  "$HOME/dev/configs/hyprland/hyprlock.conf:$HOME/.config/hypr/hyprlock.conf"

  "$HOME/dev/configs/hyprshell/config.ron:$HOME/.config/hyprshell/config.ron"
  "$HOME/dev/configs/hyprshell/config.toml:$HOME/.config/hyprshell/config.toml"
  "$HOME/dev/configs/hyprshell/styles.css:$HOME/.config/hyprshell/styles.css"

  "$HOME/dev/configs/ghostty/config:$HOME/.config/ghostty/config"

  "$HOME/dev/configs/rofi/config.rasi:$HOME/.config/rofi/config.rasi"

  "$HOME/dev/configs/xremap/config.yml:$HOME/.config/xremap/config.yml"

  "$HOME/dev/configs/dunst/dunstrc:$HOME/.config/dunst/dunstrc"

  "$HOME/dev/configs/zsh/.zshrc:$HOME/.zshrc"
)

process_entry() {
    local entry="$1"
    IFS=":" read -r src dst <<< "$entry"
    echo "Copying $src → $dst"

    mkdir -p "$(dirname "$dst")"

    if [ -d "$src" ]; then
        cp -rf "$src" "$dst"
    else
        cp -f "$src" "$dst"
    fi
}

if [ $# -gt 0 ]; then
    for entry in "$@"; do
        process_entry "$entry"
    done
else
    for entry in "${FILES[@]}"; do
        process_entry "$entry"
    done
fi

echo "Finished"