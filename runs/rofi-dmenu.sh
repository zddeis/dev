#!/usr/bin/env bash

paths=(
    "/home/zddeis/.local/share/applications"
    "/var/lib/flatpak/exports/share/applications"
    "/usr/local/share/applications"
    "/usr/share/applications"
    "/home/zddeis/Desktop/"
)

declare -A apps

build_menu() {
    for dir in "${paths[@]}"; do
        [[ -d "$dir" ]] || continue
        while IFS= read -r -d '' file; do
            name=$(grep -m1 '^Name=' "$file" 2>/dev/null | cut -d= -f2-)
            exec_cmd=$(grep -m1 '^Exec=' "$file" 2>/dev/null | cut -d= -f2-)
            icon=$(grep -m1 '^Icon=' "$file" 2>/dev/null | cut -d= -f2-)
            [[ -z "$name" || -z "$exec_cmd" ]] && continue
            exec_cmd="${exec_cmd/\%[fFuUdDnNickvm]/}"
            exec_cmd="${exec_cmd/\%[fFuUdDnNickvm]/\ }"
            exec_cmd="$(echo "$exec_cmd" | xargs)"
            if [[ -n "$icon" ]]; then
                printf "%s\0icon\x1f%s\n" "$name" "$icon"
            else
                printf "%s\n" "$name"
            fi
            apps["$name"]="$exec_cmd"
        done < <(find "$dir" -maxdepth 1 -name '*.desktop' -type f -print0 2>/dev/null)
    done
}

selection=$(build_menu | rofi -dmenu -show-icons -p "" -i -theme-str 'window {width: 500px;}')

if [[ -n "$selection" && -n "${apps[$selection]}" ]]; then
    eval "${apps[$selection]}"
fi
