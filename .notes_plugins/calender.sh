#!/usr/bin/env bash
# Calendar plugin for Notes CLI

echo "📅 Calendar:"

# Show current date in a nice format
current_date=$(date '+%A, %B %d, %Y')
current_time=$(date '+%H:%M:%S')
echo "  Today: $current_date"
echo "  Time: $current_time"

# Show upcoming week
echo "  This week:"
for i in {0..6}; do
    day_date=$(date -d "+$i days" '+%Y-%m-%d' 2>/dev/null || date -v+${i}d '+%Y-%m-%d' 2>/dev/null)
    day_name=$(date -d "+$i days" '+%a' 2>/dev/null || date -v+${i}d '+%a' 2>/dev/null)
    day_num=$(date -d "+$i days" '+%d' 2>/dev/null || date -v+${i}d '+%d' 2>/dev/null)
    
    if [[ "$i" -eq 0 ]]; then
        echo "    $day_name $day_num (Today)"
    else
        echo "    $day_name $day_num"
    fi
done

# Check for any notes on today's date
NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
today_notes=$(grep -r "$(date '+%Y-%m-%d')" "$NOTES_DIR"/*.txt 2>/dev/null | wc -l)
if [[ "$today_notes" -gt 0 ]]; then
    echo "  Notes today: $today_notes"
fi
