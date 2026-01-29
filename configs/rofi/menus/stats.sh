#!/usr/bin/env bash

cpu=$(top -bn1 | grep "Cpu(s)" | \
      awk '{print "" 100-$8 "%"}')

gpu0="N/A"

if command -v nvidia-smi &>/dev/null; then
    gpu0=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits -i 0)
    gpu1=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits -i 1 2>/dev/null)
    gpu0="${gpu0//, /, }%"
fi

mem=$(free -m | awk '/Mem:/ {printf "%.0f%%\n", ($3/$2*100)}')

disk=$(df -h / | awk 'NR==2 {print ""$3" ("$5")"}')

uptime_info=$(awk '{printf "%.2f\n", $1/3600}' /proc/uptime)

stats=(
    "   CPU: $cpu"
    "   GPU: $gpu0"
    "   Memory: $mem"
    "   Disk: $disk"
    "󱎫   Uptime: $uptime_info Hours"
)

printf "%s\n" "${stats[@]}" | rofi -dmenu -p "Stats" -i -no-show-match -no-sort