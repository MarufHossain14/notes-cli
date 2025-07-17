#!/usr/bin/env bash
# Backup plugin for Notes CLI

NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
BACKUP_DIR="$NOTES_DIR/backups"

echo "💾 Backup Operations:"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create timestamped backup
backup_name="notes_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
backup_path="$BACKUP_DIR/$backup_name"

echo "  Creating backup: $backup_name"

if tar -czf "$backup_path" -C "$NOTES_DIR" . 2>/dev/null; then
    backup_size=$(du -h "$backup_path" | cut -f1)
    echo "  ✅ Backup created successfully ($backup_size)"
else
    echo "  ❌ Backup failed"
    exit 1
fi

# List recent backups
echo "  Recent backups:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -3 | awk '{print "    " $9 " (" $5 ")"}' || echo "    No previous backups"

# Clean old backups (keep last 5)
backup_count=$(ls "$BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
if [[ "$backup_count" -gt 5 ]]; then
    echo "  Cleaning old backups..."
    ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +6 | xargs rm -f
    echo "  ✅ Old backups cleaned"
fi 