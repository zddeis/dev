#!/bin/bash

# List of files and their target destinations
# Format: "source_file:destination_file"
FILES=( 
  "$HOME/dev/configs/discord/Acrilic.css:$HOME/.config/Vencord/themes/Acrilic.css"
  "$HOME/dev/configs/hyprland/hyprland.conf:$HOME/.config/hypr/hyprland.conf"
  "$HOME/dev/configs/hyprland/hyprpaper.conf:$HOME/.config/hypr/hyprpaper.conf"
  "$HOME/dev/configs/wofi/config:$HOME/.config/wofi/config"
  "$HOME/dev/configs/wofi/style.css:$HOME/.config/wofi/style.css"
  "$HOME/dev/configs/ghostty/config:$HOME/.config/ghostty/config"
  "$HOME/dev/configs/zsh/.zshrc:$HOME/.zshrc"
)

for entry in "${FILES[@]}"; do
    IFS=":" read -r src dst <<< "$entry"
    echo "Copying $src → $dst"
    
    # Create target directory if it doesn’t exist
    mkdir -p "$(dirname "$dst")"
    
    # Copy file
    cp -f "$src" "$dst"
done

echo "Finished"