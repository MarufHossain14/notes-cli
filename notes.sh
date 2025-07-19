#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

# === Version Info ===
VERSION="2.0.0"
AUTHOR="Your Name"
DESCRIPTION="A production-ready terminal notes CLI with encryption, backup, and sync"

# === Configuration ===
CONFIG_FILE="$HOME/.notesrc"
DEFAULT_CONFIG_FILE="$(dirname "$0")/.notesrc"

# Load user config if exists, otherwise create from default
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
    elif [[ -f "$DEFAULT_CONFIG_FILE" ]]; then
    cp "$DEFAULT_CONFIG_FILE" "$CONFIG_FILE"
    source "$CONFIG_FILE"
fi

# === Default Settings ===
EDITOR="${EDITOR:-nano}"
GPG_USER="${GPG_USER:-}"
NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
PRIVATE_DIR="$NOTES_DIR/private"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"
DEFAULT_CATEGORIES=("Work" "Personal" "Journal" "Ideas" "Tasks")
THEME="${THEME:-minimal}"
AUTO_SYNC="${AUTO_SYNC:-false}"
PLUGINS_DIR="${PLUGINS_DIR:-$(dirname "$0")/.notes_plugins}"

# === Security & Validation ===
validate_environment() {
    # Check for required commands
    local required_commands=("bash" "grep" "sed" "date" "mkdir" "cp" "rm")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            error "Required command '$cmd' not found. Please install it."
            exit 1
        fi
    done
    
    # Check for optional but recommended commands
    local optional_commands=("fzf" "gpg" "git")
    for cmd in "${optional_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            warning "Optional command '$cmd' not found. Some features may be limited."
        fi
    done
    
    # Validate GPG setup for encryption features
    if [[ -n "$GPG_USER" ]] && ! gpg --list-keys "$GPG_USER" &>/dev/null; then
        warning "GPG key for '$GPG_USER' not found. Encryption features will be disabled."
        GPG_USER=""
    fi
    
    # Ensure directories exist
    mkdir -p "$NOTES_DIR" "$PRIVATE_DIR" "$PLUGINS_DIR"
}

# === Themes ===
set_theme() {
    case "$THEME" in
        minimal)
            RED="\e[91m"; GREEN="\e[92m"; YELLOW="\e[93m"
            BLUE="\e[96m"; MAGENTA="\e[95m"; CYAN="\e[94m";
            GRAY="\e[90m"; RESET="\e[0m"
        ;;
        solarized)
            RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"
            BLUE="\e[34m"; MAGENTA="\e[35m"; CYAN="\e[36m";
            GRAY="\e[90m"; RESET="\e[0m"
        ;;
        gruvbox)
            RED="\e[91m"; GREEN="\e[92m"; YELLOW="\e[93m"
            BLUE="\e[94m"; MAGENTA="\e[95m"; CYAN="\e[96m";
            GRAY="\e[90m"; RESET="\e[0m"
        ;;
        dracula)
            RED="\e[38;5;203m"; GREEN="\e[38;5;84m"; YELLOW="\e[38;5;227m"
            BLUE="\e[38;5;68m"; MAGENTA="\e[38;5;141m"; CYAN="\e[38;5;86m";
            GRAY="\e[38;5;240m"; RESET="\e[0m"
        ;;
        *)
            RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"
            BLUE="\e[34m"; MAGENTA="\e[35m"; CYAN="\e[36m";
            GRAY="\e[90m"; RESET="\e[0m"
        ;;
    esac
}

# === Utility Functions ===
error()   { echo -e "${RED}[ERROR] $1${RESET}" >&2; }
warning() { echo -e "${YELLOW}[WARNING] $1${RESET}" >&2; }
info()    { echo -e "${GREEN}[INFO] $1${RESET}"; }
success() { echo -e "${GREEN}[SUCCESS] $1${RESET}"; }
pause()   { read -rp "Press enter to continue..."; }

# === File Operations ===
safe_filename() {
    local filename="$1"
    # Remove or replace unsafe characters
    echo "$filename" | sed 's/[^a-zA-Z0-9._-]//g'
}

backup_notes() {
    local src="$1"
    [[ ! -f "$src" ]] && return 1
    
    local base=$(basename "$src")
    local name="${base%.*}"
    local ext="${base##*.}"
    local backup_file="$NOTES_DIR/backup_${name}_$(date +%Y%m%d_%H%M%S).${ext}"
    
    cp "$src" "$backup_file"
    info "Backup created: $(basename "$backup_file")"
    
    # Clean old backups
    find "$NOTES_DIR" -maxdepth 1 -type f -name "backup_${name}_*" -mtime +"$BACKUP_RETENTION_DAYS" -exec rm {} \; 2>/dev/null || true
}

# === Category Management ===
choose_category() {
    echo -e "${CYAN}Choose a category:${RESET}"
    for i in "${!DEFAULT_CATEGORIES[@]}"; do
        echo -e "${YELLOW}$((i + 1)).${RESET} ${DEFAULT_CATEGORIES[$i]}"
    done
    echo -e "${YELLOW}$(( ${#DEFAULT_CATEGORIES[@]} + 1 )).${RESET} Custom"
    
    read -rp "Enter choice [1-$(( ${#DEFAULT_CATEGORIES[@]} + 1 ))]: " cat_choice
    
    if [[ $cat_choice =~ ^[1-9][0-9]*$ ]] && (( cat_choice >= 1 && cat_choice <= ${#DEFAULT_CATEGORIES[@]} )); then
        local selected="${DEFAULT_CATEGORIES[$((cat_choice - 1))]}"
        filepath="$NOTES_DIR/$(echo "$selected" | tr '[:upper:]' '[:lower:]').txt"
        elif (( cat_choice == ${#DEFAULT_CATEGORIES[@]} + 1 )); then
        read -rp "Enter custom category name: " custom_cat
        local safe_name=$(safe_filename "$custom_cat")
        filepath="$NOTES_DIR/${safe_name}.txt"
    else
        error "Invalid category choice."
        return 1
    fi
    
    # Ensure file exists
    [[ ! -f "$filepath" ]] && touch "$filepath"
}

# === Plugin System ===
run_plugins() {
    if [[ -d "$PLUGINS_DIR" ]]; then
        for plugin in "$PLUGINS_DIR"/*.sh; do
            if [[ -f "$plugin" && -x "$plugin" ]]; then
                "$plugin" "$@"
                elif [[ -f "$plugin" ]]; then
                bash "$plugin" "$@"
            fi
        done
    fi
}

# === Core Commands ===
add_note() {
    choose_category || exit 1
    
    echo -e "${CYAN}Adding note to: $(basename "$filepath")${RESET}"
    echo "----- Note taken on $(date '+%Y-%m-%d %H:%M:%S') -----" >> "$filepath"
    echo "Write your note below (press CTRL+D when done):"
    cat >> "$filepath"
    echo "" >> "$filepath"
    
    success "Note saved to $(basename "$filepath")"
    [[ "$AUTO_SYNC" == true ]] && sync_notes
}

list_notes() {
    choose_category || exit 1
    
    if [[ ! -s "$filepath" ]]; then
        echo -e "${YELLOW}No notes found in $(basename "$filepath")${RESET}"
        return
    fi
    
    echo -e "${MAGENTA}Notes in $(basename "$filepath"):${RESET}"
    echo "----------------------------------------"
    nl "$filepath"
    echo "----------------------------------------"
}

delete_note() {
    choose_category || exit 1
    
    if [[ ! -s "$filepath" ]]; then
        echo -e "${YELLOW}No notes to delete in $(basename "$filepath")${RESET}"
        return
    fi
    
    echo -e "${CYAN}Current notes:${RESET}"
    nl "$filepath"
    
    read -rp "Enter the note number to delete: " num
    if [[ ! $num =~ ^[0-9]+$ ]]; then
        error "Invalid note number."
        return 1
    fi
    
    local total_lines=$(wc -l < "$filepath")
    if (( num < 1 || num > total_lines )); then
        error "Note number out of range (1-$total_lines)."
        return 1
    fi
    
    backup_notes "$filepath"
    sed -i "${num}d" "$filepath"
    success "Deleted note #$num"
    [[ "$AUTO_SYNC" == true ]] && sync_notes
}

edit_note() {
    choose_category || exit 1
    
    if [[ ! -s "$filepath" ]]; then
        echo -e "${YELLOW}No notes to edit in $(basename "$filepath")${RESET}"
        return
    fi
    
    echo -e "${CYAN}Current notes:${RESET}"
    nl "$filepath"
    
    read -rp "Enter the note number to edit: " num
    if [[ ! $num =~ ^[0-9]+$ ]]; then
        error "Invalid note number."
        return 1
    fi
    
    local total_lines=$(wc -l < "$filepath")
    if (( num < 1 || num > total_lines )); then
        error "Note number out of range (1-$total_lines)."
        return 1
    fi
    
    local current=$(sed -n "${num}p" "$filepath")
    echo -e "${CYAN}Current:${RESET} $current"
    read -rp "New content: " new_content
    
    backup_notes "$filepath"
    sed -i "${num}s/.*/$new_content/" "$filepath"
    success "Note #$num updated"
    [[ "$AUTO_SYNC" == true ]] && sync_notes
}

journal_today() {
    local filepath="$NOTES_DIR/journal-$(date +%Y-%m-%d).txt"
    echo -e "${CYAN}Writing to today's journal: $(basename "$filepath")${RESET}"
    echo "----- Journal entry on $(date '+%Y-%m-%d %H:%M:%S') -----" >> "$filepath"
    cat >> "$filepath"
    echo "" >> "$filepath"
    success "Journal entry saved"
    [[ "$AUTO_SYNC" == true ]] && sync_notes
}

search_notes() {
    read -rp "Enter keyword to search: " keyword
    if [[ -z "$keyword" ]]; then
        error "Search keyword cannot be empty."
        return 1
    fi
    
    echo -e "${MAGENTA}Search results for '$keyword':${RESET}"
    echo "----------------------------------------"
    if grep --color=always -i "$keyword" "$NOTES_DIR"/*.txt 2>/dev/null; then
        echo "----------------------------------------"
    else
        echo -e "${YELLOW}No matches found.${RESET}"
    fi
}

fuzzy_view() {
    if ! command -v fzf &>/dev/null; then
        error "fzf not installed. Install it first:"
        echo "  Ubuntu/Debian: sudo apt install fzf"
        echo "  macOS: brew install fzf"
        echo "  Windows: choco install fzf"
        return 1
    fi
    
    local file=$(find "$NOTES_DIR" -type f -name "*.txt" | fzf --preview 'cat {}' --preview-window=right:60%)
    [[ -z "$file" ]] && { info "No file selected."; return; }
    
    clear
    echo -e "${GREEN}--- Viewing: $(basename "$file") ---${RESET}"
    echo "----------------------------------------"
    cat "$file"
    echo "----------------------------------------"
    pause
}

tag_filter() {
    read -rp "Enter tag to search (include #): " tag
    if [[ -z "$tag" ]]; then
        error "Tag cannot be empty."
        return 1
    fi
    
    echo -e "${MAGENTA}Searching for tag '$tag':${RESET}"
    echo "----------------------------------------"
    if grep --color=always -r "$tag" "$NOTES_DIR"/*.txt 2>/dev/null; then
        echo "----------------------------------------"
    else
        echo -e "${YELLOW}No matches found.${RESET}"
    fi
    pause
}

export_markdown() {
    choose_category || exit 1
    
    local export_file="$NOTES_DIR/exported_$(basename "$filepath" .txt)_$(date +%Y%m%d_%H%M%S).md"
    {
        echo "# Notes from $(basename "$filepath" .txt)"
        echo ""
        echo "*Exported on $(date '+%Y-%m-%d %H:%M:%S')*"
        echo ""
        cat "$filepath"
    } > "$export_file"
    
    success "Exported to $(basename "$export_file")"
}

list_backups() {
    local backups=( "$NOTES_DIR"/backup_* )
    if [[ ${#backups[@]} -eq 0 ]] || [[ ! -f "${backups[0]}" ]]; then
        echo -e "${YELLOW}No backups found.${RESET}"
        return
    fi
    
    echo -e "${CYAN}Available backups:${RESET}"
    echo "----------------------------------------"
    ls -lh "$NOTES_DIR"/backup_* 2>/dev/null | awk '{print $9, $5, $6, $7, $8}' || true
    echo "----------------------------------------"
    pause
}

restore_backup() {
    if ! command -v fzf &>/dev/null; then
        error "fzf required for backup restoration. Please install fzf first."
        return 1
    fi
    
    local backup_file=$(find "$NOTES_DIR" -name "backup_*" 2>/dev/null | fzf)
    [[ -z "$backup_file" ]] && { info "No backup selected."; return; }
    
    local base=$(basename "$backup_file")
    local orig="${base#backup_}"
    orig="${orig%_[0-9]*_[0-9]*.txt}"
    local original_file="$NOTES_DIR/$orig.txt"
    
    echo -e "${CYAN}Restoring $backup_file to $original_file${RESET}"
    read -rp "Are you sure? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        cp "$backup_file" "$original_file"
        success "Backup restored successfully"
    else
        info "Restoration cancelled."
    fi
}

edit_external() {
    choose_category || exit 1
    echo -e "${CYAN}Opening $(basename "$filepath") in $EDITOR...${RESET}"
    $EDITOR "$filepath"
    success "Edit completed"
    [[ "$AUTO_SYNC" == true ]] && sync_notes
}

sync_notes() {
    if ! command -v git &>/dev/null; then
        error "Git not installed. Sync feature disabled."
        return 1
    fi
    
    cd "$NOTES_DIR" || { error "Cannot access notes directory"; return 1; }
    
    # Initialize git if not already done
    if [[ ! -d ".git" ]]; then
        git init
        echo "*.gpg" > .gitignore
        echo "backup_*" >> .gitignore
        git add .gitignore
        git commit -m "Initial commit"
        info "Git repository initialized. Add a remote with: git remote add origin <your-repo-url>"
        return
    fi
    
    # Check for changes
    if git diff --quiet && git diff --cached --quiet; then
        info "No changes to sync"
        return
    fi
    
    git add .
    git commit -m "📝 Sync notes: $(date '+%Y-%m-%d %H:%M:%S')" || { error "Commit failed"; return 1; }
    
    # Try to push if remote exists
    if git remote -v | grep -q origin; then
        git push || warning "Push failed. Check your remote configuration."
    else
        info "No remote configured. Use 'git remote add origin <url>' to set up sync."
    fi
}

encrypt_note() {
    if [[ -z "$GPG_USER" ]]; then
        error "GPG encryption not configured. Set GPG_USER in your config."
        return 1
    fi
    
    read -rp "Enter a title for your encrypted note: " title
    if [[ -z "$title" ]]; then
        error "Title cannot be empty."
        return 1
    fi
    
    local safe_title=$(safe_filename "$title")
    local tmpfile=$(mktemp)
    
    echo -e "${CYAN}Write your private note below (CTRL+D when done):${RESET}"
    cat > "$tmpfile"
    
    if gpg --yes --encrypt --recipient "$GPG_USER" --output "$PRIVATE_DIR/${safe_title}.gpg" "$tmpfile" 2>/dev/null; then
        success "Encrypted note saved to private/${safe_title}.gpg"
    else
        error "Encryption failed. Check your GPG key."
    fi
    
    rm -f "$tmpfile"
}

decrypt_note() {
    if [[ -z "$GPG_USER" ]]; then
        error "GPG encryption not configured."
        return 1
    fi
    
    if ! command -v fzf &>/dev/null; then
        error "fzf required for note selection. Please install fzf first."
        return 1
    fi
    
    local file=$(find "$PRIVATE_DIR" -type f -name "*.gpg" 2>/dev/null | fzf)
    [[ -z "$file" ]] && { info "No encrypted note selected."; return; }
    
    echo -e "${CYAN}Decrypting $(basename "$file")...${RESET}"
    if gpg --quiet --decrypt "$file" 2>/dev/null | less; then
        success "Note decrypted successfully"
    else
        error "Decryption failed. Check your GPG key."
    fi
}

dashboard() {
    echo -e "${CYAN}📊 Notes Dashboard - $(date '+%A, %B %d, %Y')${RESET}"
    echo "========================================"
    
    # Today's journal
    local journal_file="$NOTES_DIR/journal-$(date +%Y-%m-%d).txt"
    if [[ -f "$journal_file" ]]; then
        echo -e "${MAGENTA}📓 Today's Journal:${RESET}"
        tail -n 3 "$journal_file" | sed 's/^/  /'
    else
        echo -e "${YELLOW}📓 No journal entry today${RESET}"
    fi
    echo
    
    # Recent notes count
    local recent_count=$(find "$NOTES_DIR" -name "*.txt" -mtime -7 | wc -l)
    echo -e "${BLUE}📝 Recent notes (last 7 days): $recent_count${RESET}"
    
    # Tags used today
    echo -e "${GREEN}🏷️ Tags used today:${RESET}"
    local tags=$(grep -r "$(date +%Y-%m-%d)" "$NOTES_DIR"/*.txt 2>/dev/null | grep -o '#[A-Za-z0-9_]*' | sort | uniq)
    if [[ -n "$tags" ]]; then
        echo "$tags" | sed 's/^/  /'
    else
        echo -e "  ${YELLOW}No tags found${RESET}"
    fi
    echo
    
    # Run plugins
    if [[ -d "$PLUGINS_DIR" ]]; then
        echo -e "${CYAN}🔌 Plugin Status:${RESET}"
        run_plugins
    fi
    
    echo "========================================"
    pause
}

show_help() {
    cat <<EOF
📝 Notes CLI - Simple note management

Quick Commands:
  notes           Interactive menu (easiest way)
  notes add       Add a new note
  notes list      View your notes
  notes journal   Today's journal entry
  notes search    Find notes

Other Commands:
  edit, delete, export, sync, config

Tips:
  • Just type 'notes' for an interactive menu
  • Use 'notes config' to customize settings
  • Type 'notes menu' for full command list
EOF
}

show_menu() {
    cat <<EOF
📝 Notes CLI v$VERSION

CORE COMMANDS:
  add         Add a new note
  list        List notes by category
  journal     Today's journal entry
  search      Search all notes
  edit        Edit existing note
  delete      Delete a note

ADVANCED:
  fuzzy       Fuzzy search (requires fzf)
  tag         Filter by tags (#work)
  encrypt     Encrypted notes (requires GPG)
  sync        Git sync
  export      Export to Markdown
  dashboard   Daily summary

UTILITIES:
  config      Show settings
  backups     List backups
  plugins     Run plugins
  help        Quick help
EOF
}

show_config() {
    echo -e "${CYAN}📋 Current Configuration:${RESET}"
    echo "========================================"
    echo -e "Notes Directory: ${YELLOW}$NOTES_DIR${RESET}"
    echo -e "Private Directory: ${YELLOW}$PRIVATE_DIR${RESET}"
    echo -e "Editor: ${YELLOW}$EDITOR${RESET}"
    echo -e "Theme: ${YELLOW}$THEME${RESET}"
    echo -e "Auto Sync: ${YELLOW}$AUTO_SYNC${RESET}"
    echo -e "Backup Retention: ${YELLOW}${BACKUP_RETENTION_DAYS} days${RESET}"
    echo -e "Plugins Directory: ${YELLOW}$PLUGINS_DIR${RESET}"
    if [[ -n "$GPG_USER" ]]; then
        echo -e "GPG User: ${YELLOW}$GPG_USER${RESET}"
    else
        echo -e "GPG User: ${RED}Not configured${RESET}"
    fi
    echo -e "Categories: ${YELLOW}${DEFAULT_CATEGORIES[*]}${RESET}"
    echo "========================================"
}

show_interactive_menu() {
    while true; do
        clear
        show_menu
        echo ""
        echo "What would you like to do?"
        echo "(Type a command or 'q' to quit)"
        echo -n "> "
        
        read -r choice
        
        case "$choice" in
            q|quit|exit)
                echo "Goodbye!"
                exit 0
            ;;
            add|a) add_note ;;
            list|l) list_notes ;;
            journal|j) journal_today ;;
            search|s)
                echo -n "Search for: "
                read -r term
                search_notes "$term"
            ;;
            edit|e) edit_note ;;
            delete|d) delete_note ;;
            fuzzy|f) fuzzy_view ;;
            tag|t)
                echo -n "Tag to filter: "
                read -r tag
                tag_filter "$tag"
            ;;
            encrypt) encrypt_note ;;
            sync) sync_notes ;;
            export) export_markdown ;;
            dashboard) dashboard ;;
            config|c) show_config; pause ;;
            backups|b) list_backups ;;
            plugins|p) run_plugins ;;
            help|h) show_help; pause ;;
            menu|m) continue ;;
            "")
                echo "Please enter a command"
                sleep 1
            ;;
            *)
                echo "Unknown command: $choice"
                echo "Type 'help' to see available commands"
                sleep 2
            ;;
        esac
        
        if [[ "$choice" != "config" && "$choice" != "c" && "$choice" != "help" && "$choice" != "h" && "$choice" != "menu" && "$choice" != "m" && "$choice" != "" ]]; then
            echo ""
            echo "Press Enter to continue..."
            read -r
        fi
    done
}

# === Main Execution ===
main() {
    # Initialize
    set_theme
    validate_environment
    
    # If no command provided, show interactive menu
    if [[ $# -eq 0 ]]; then
        show_interactive_menu
        return
    fi
    
    local cmd="${1:-help}"
    shift || true
    
    case "$cmd" in
        add)       add_note ;;
        list)      list_notes ;;
        delete)    delete_note ;;
        edit)      edit_note ;;
        journal)   journal_today ;;
        search)    search_notes ;;
        fuzzy)     fuzzy_view ;;
        tag)       tag_filter ;;
        export)    export_markdown ;;
        backups)   list_backups ;;
        restore)   restore_backup ;;
        external)  edit_external ;;
        encrypt)   encrypt_note ;;
        decrypt)   decrypt_note ;;
        sync)      sync_notes ;;
        plugins)   run_plugins ;;
        dashboard) dashboard ;;
        config)    show_config ;;
        help)      show_help ;;
        menu)      show_interactive_menu ;;
        version)   echo "Notes CLI v$VERSION" ;;
        *)
            # Try to run as plugin
            local plugin_script="$PLUGINS_DIR/${cmd}.sh"
            if [[ -x "$plugin_script" ]]; then
                "$plugin_script" "$@"
                elif [[ -f "$plugin_script" ]]; then
                bash "$plugin_script" "$@"
            else
                error "Unknown command: $cmd"
                echo -e "Try: ${YELLOW}notes help${RESET} for available commands."
                exit 1
            fi
        ;;
    esac
}

# Run main function with all arguments
main "$@"