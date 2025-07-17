#!/usr/bin/env bash
set -euo pipefail

echo "📝 Notes CLI Installer"
echo "========================"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOTES_SCRIPT="$SCRIPT_DIR/notes.sh"

# Check if notes.sh exists
if [[ ! -f "$NOTES_SCRIPT" ]]; then
    echo "ERROR: notes.sh not found in current directory"
    exit 1
fi

echo "STEP: Making notes.sh executable..."
chmod +x "$NOTES_SCRIPT"

echo "STEP: Creating symlink..."
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Add to PATH if not already there
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.zshrc" 2>/dev/null || true
    echo "INFO: Added $BIN_DIR to PATH in shell config files"
fi

# Create symlink
SYMLINK="$BIN_DIR/notes"
if [[ -L "$SYMLINK" ]]; then
    rm "$SYMLINK"
fi
ln -sf "$NOTES_SCRIPT" "$SYMLINK"

# Copy config if it doesn't exist
USER_CONFIG="$HOME/.notesrc"
if [[ ! -f "$USER_CONFIG" ]]; then
    echo "STEP: Creating user configuration..."
    cp "$SCRIPT_DIR/.notesrc" "$USER_CONFIG"
    echo "INFO: Configuration created at $USER_CONFIG"
fi

# Create notes directory
echo "STEP: Creating notes directory..."
mkdir -p "$HOME/notes"

echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. Edit your config: nano ~/.notesrc"
echo "3. Start using: notes help"
echo "" 