#!/usr/bin/bash
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

# === Detect OS ===
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*)    echo "windows";;
        MINGW*)     echo "windows";;
        MSYS*)      echo "windows";;
        *)          echo "unknown";;
    esac
}

# === Check Dependencies ===
check_dependencies() {
    step "Checking dependencies..."
    
    local missing_deps=()
    
    # Required dependencies
    for cmd in bash grep sed date mkdir cp rm; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    # Optional but recommended
    local optional_deps=("fzf" "gpg" "git")
    for cmd in "${optional_deps[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            warning "$cmd not found. Some features will be limited."
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        return 1
    fi
    
    info "All required dependencies found!"
}

# === Install Dependencies ===
install_dependencies() {
    local os=$(detect_os)
    
    case "$os" in
        linux)
            if command -v apt-get &>/dev/null; then
                step "Installing dependencies on Ubuntu/Debian..."
                sudo apt-get update
                sudo apt-get install -y fzf gpg git
                elif command -v yum &>/dev/null; then
                step "Installing dependencies on CentOS/RHEL..."
                sudo yum install -y fzf gnupg git
                elif command -v pacman &>/dev/null; then
                step "Installing dependencies on Arch Linux..."
                sudo pacman -S --noconfirm fzf gnupg git
            else
                warning "Package manager not detected. Please install fzf, gpg, and git manually."
            fi
        ;;
        macos)
            if command -v brew &>/dev/null; then
                step "Installing dependencies on macOS..."
                brew install fzf gnupg git
            else
                warning "Homebrew not found. Please install it first: https://brew.sh"
                warning "Then run: brew install fzf gnupg git"
            fi
        ;;
        windows)
            if command -v choco &>/dev/null; then
                step "Installing dependencies on Windows..."
                choco install fzf gnupg git
            else
                warning "Chocolatey not found. Please install it first: https://chocolatey.org"
                warning "Then run: choco install fzf gnupg git"
            fi
        ;;
        *)
            warning "Unknown OS. Please install fzf, gpg, and git manually."
        ;;
    esac
}

# === Main Installation ===
main() {
    echo -e "${BLUE}?? Notes CLI Installer${RESET}"
    echo "================================"
    
    # Get script directory
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local notes_script="$script_dir/notes.sh"
    
    # Check if notes.sh exists
    if [[ ! -f "$notes_script" ]]; then
        error "notes.sh not found in current directory"
        exit 1
    fi
    
    # Check dependencies
    check_dependencies
    
    # Ask about installing optional dependencies
    echo
    read -rp "Install optional dependencies (fzf, gpg, git)? [y/N]: " install_opt
    if [[ "$install_opt" =~ ^[Yy]$ ]]; then
        install_dependencies
    fi
    
    # Make script executable
    step "Making notes.sh executable..."
    chmod +x "$notes_script"
    
    # Create symlink
    step "Creating symlink..."
    local bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
        echo "export PATH=\"$bin_dir:\$PATH\"" >> "$HOME/.bashrc"
        echo "export PATH=\"$bin_dir:\$PATH\"" >> "$HOME/.zshrc" 2>/dev/null || true
        info "Added $bin_dir to PATH in shell config files"
    fi
    
    # Create symlink
    local symlink="$bin_dir/notes"
    if [[ -L "$symlink" ]]; then
        rm "$symlink"
    fi
    ln -sf "$notes_script" "$symlink"
    
    # Copy config if it doesn't exist
    local user_config="$HOME/.notesrc"
    if [[ ! -f "$user_config" ]]; then
        step "Creating user configuration..."
        cp "$script_dir/.notesrc" "$user_config"
        info "Configuration created at $user_config"
    fi
    
    # Create notes directory
    step "Creating notes directory..."
    mkdir -p "$HOME/notes"
    
    # Success message
    echo
    echo -e "${GREEN}? Installation completed successfully!${RESET}"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Edit your config: nano ~/.notesrc"
    echo "3. Set up GPG for encryption (optional):"
    echo "   gpg --full-generate-key"
    echo "   Then add GPG_USER to ~/.notesrc"
    echo "4. Start using: notes help"
    echo
    echo "For Git sync, create a repository and add remote:"
    echo "  cd ~/notes"
    echo "  git remote add origin <your-repo-url>"
    echo
}

# Run installation
main "$@"
