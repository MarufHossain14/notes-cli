#!/usr/bin/env bash
# Battery plugin for Notes CLI

echo "🔋 System Status:"

# Check battery status (Linux/macOS)
if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f "/sys/class/power_supply/BAT0/capacity" ]]; then
        battery_level=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        battery_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        echo "  Battery: ${battery_level}% ($battery_status)"
    fi
elif [[ "$(uname -s)" == "Darwin" ]]; then
    battery_info=$(pmset -g batt 2>/dev/null | grep -E "([0-9]+)%" | head -1)
    if [[ -n "$battery_info" ]]; then
        echo "  $battery_info"
    fi
fi

# Show system uptime
uptime_info=$(uptime 2>/dev/null | sed 's/.*up \([^,]*\),.*/\1/')
if [[ -n "$uptime_info" ]]; then
    echo "  Uptime: $uptime_info"
fi

# Show disk usage
if command -v df &>/dev/null; then
    disk_usage=$(df -h . | tail -1 | awk '{print $5}')
    echo "  Disk usage: $disk_usage"
fi
