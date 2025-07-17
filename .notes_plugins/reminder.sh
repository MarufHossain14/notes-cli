#!/usr/bin/env bash
# Reminder plugin for Notes CLI

NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
REMINDERS_FILE="$NOTES_DIR/reminders.txt"

# Ensure reminders file exists
[[ ! -f "$REMINDERS_FILE" ]] && touch "$REMINDERS_FILE"

echo "⏰ Reminders:"
if [[ -s "$REMINDERS_FILE" ]]; then
    # Show recent reminders
    echo "  Recent reminders:"
    tail -n 3 "$REMINDERS_FILE" | sed 's/^/    /'
else
    echo "  No reminders set"
fi

# Check if user wants to add a reminder
read -rp "Add a new reminder? (y/N): " add_reminder
if [[ "$add_reminder" =~ ^[Yy]$ ]]; then
    read -rp "Enter reminder text: " reminder_text
    if [[ -n "$reminder_text" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $reminder_text" >> "$REMINDERS_FILE"
        echo "  ✅ Reminder added!"
    fi
fi
