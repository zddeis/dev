#!/bin/bash

PROJECTS_DIR="$HOME/projects"
ICON="   "
ADD_PROJECT_OPTION="   Add new Project"

mapfile -t folders < <(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d | sort)

declare -A menu
menu["$ADD_PROJECT_OPTION"]="add_new"

for folder in "${folders[@]}"; do
    name="$(basename "$folder")"
    menu["$ICON$name"]="$folder"
done

menu_keys=("$ADD_PROJECT_OPTION")
for folder in "${folders[@]}"; do
    menu_keys+=("$ICON$(basename "$folder")")
done

option=$(printf "%s\n" "${menu_keys[@]}" | rofi -dmenu -p "Projects" -i)

if [[ -n "$option" && -n "${menu[$option]}" ]]; then
    if [[ "${menu[$option]}" == "add_new" ]]; then
    
        new_project=$(rofi -dmenu -p "New project name:")
        if [[ -n "$new_project" ]]; then
            new_path="$PROJECTS_DIR/$new_project"
            mkdir -p "$new_path"
            code "$new_path"
        fi
    else
        code "${menu[$option]}"
    fi
fi
