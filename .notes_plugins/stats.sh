#!/usr/bin/env bash
# Stats plugin for Notes CLI

NOTES_DIR="${NOTES_DIR:-$HOME/notes}"

echo "📊 Note Statistics:"

# Count total notes
total_files=$(find "$NOTES_DIR" -name "*.txt" 2>/dev/null | wc -l)
echo "  Total note files: $total_files"

# Count total lines
total_lines=$(find "$NOTES_DIR" -name "*.txt" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
echo "  Total lines: $total_lines"

# Most recent note
recent_file=$(find "$NOTES_DIR" -name "*.txt" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
if [[ -n "$recent_file" ]]; then
    recent_name=$(basename "$recent_file")
    echo "  Most recent: $recent_name"
fi

# Notes this week
week_notes=$(find "$NOTES_DIR" -name "*.txt" -mtime -7 2>/dev/null | wc -l)
echo "  Notes this week: $week_notes"

# Tags used
tags=$(grep -r '#' "$NOTES_DIR"/*.txt 2>/dev/null | grep -o '#[A-Za-z0-9_]*' | sort | uniq -c | sort -nr | head -5)
if [[ -n "$tags" ]]; then
    echo "  Top tags:"
    echo "$tags" | sed 's/^/    /'
fi 