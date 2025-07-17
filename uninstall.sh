#!/usr/bin/env bash
set -euo pipefail

# === Colors ===
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# === Functions ===
error()   { echo -e "${RED}[ERROR] $1${RESET}" >&2; }
info()    { echo -e "${GREEN}[INFO] $1${RESET}"; }
warning() { echo -e "${YELLOW}[WARNING] $1${RESET}"; }
step()    { echo -e "${BLUE}[STEP] $1${RESET}"; }

# === Main Uninstall ===
main() {
    echo -e "${BLUE}📝 Notes CLI Uninstaller${RESET}"
    echo "================================"
    
    # Remove symlink
    local symlink="$HOME/.local/bin/notes"
    if [[ -L "$symlink" ]]; then
        step "Removing symlink..."
        rm "$symlink"
        info "Removed symlink: $symlink"
    else
        warning "Symlink not found: $symlink"
    fi
    
    # Ask about removing configuration
    echo
    read -rp "Remove configuration file (~/.notesrc)? [y/N]: " remove_config
    if [[ "$remove_config" =~ ^[Yy]$ ]]; then
        if [[ -f "$HOME/.notesrc" ]]; then
            step "Removing configuration..."
            rm "$HOME/.notesrc"
            info "Removed configuration: $HOME/.notesrc"
        else
            warning "Configuration file not found"
        fi
    fi
    
    # Ask about removing notes directory
    echo
    read -rp "Remove notes directory (~/notes)? [y/N]: " remove_notes
    if [[ "$remove_notes" =~ ^[Yy]$ ]]; then
        if [[ -d "$HOME/notes" ]]; then
            step "Removing notes directory..."
            rm -rf "$HOME/notes"
            info "Removed notes directory: $HOME/notes"
        else
            warning "Notes directory not found"
        fi
    fi
    
    # Success message
    echo
    echo -e "${GREEN}✅ Uninstallation completed!${RESET}"
    echo
    echo "Note: You may need to restart your terminal for PATH changes to take effect."
    echo "If you want to reinstall later, just run the install script again."
}

# Run uninstall
main "$@" 