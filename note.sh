#!/bin/bash

# === Function to create a timestamped backup of the given note file ===
backup_notes() {
    cp "$1" "notes/backup_$(basename "$1")_$(date +%Y%m%d_%H%M%S).txt"
}

# === Color Codes for Terminal Output ===
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"

# === Create the notes directory if it doesn't exist ===
mkdir -p notes

# === Function to choose a note category and set the file path ===
choose_category() {
    echo -e "${CYAN}Choose a category:${RESET}"
    echo -e "${YELLOW}1.${RESET} Work"
    echo -e "${YELLOW}2.${RESET} Personal"
    echo -e "${YELLOW}3.${RESET} Journal"
    read -p "Enter choice [1-3]: " cat_choice
    
    case $cat_choice in
        1) category="work.txt" ;;
        2) category="personal.txt" ;;
        3) category="journal.txt" ;;
        *) echo -e "${RED}Invalid choice.${RESET}"; return 1 ;;
    esac
    
    filepath="notes/$category"
}

# === Main Program Loop ===
while true; do
    echo ""
    echo -e "${CYAN}What would you like to do?${RESET}"
    echo -e "${YELLOW}1.${RESET} Add a note"
    echo -e "${YELLOW}2.${RESET} List notes"
    echo -e "${YELLOW}3.${RESET} Delete a note"
    echo -e "${YELLOW}4.${RESET} Search notes"
    echo -e "${YELLOW}5.${RESET} Fuzzy search & view notes"
    echo -e "${YELLOW}6.${RESET} Edit a note"
    echo -e "${YELLOW}7.${RESET} Daily Journal (auto-date)"
    echo -e "${YELLOW}8.${RESET} Filter notes by tag"
    echo -e "${YELLOW}9.${RESET} Exit"
    read -p "Enter choice [1-9]: " choice

    
    case $choice in
        1)
            choose_category || continue
            echo "Write your note below (press CTRL+D when done):"
            echo "----- Note taken on $(date) -----" >> "$filepath"
            cat >> "$filepath"
            echo "" >> "$filepath"
            echo -e "${GREEN}Note saved to $filepath!${RESET}"
        ;;
        
        2)
            choose_category || continue
            echo -e "${MAGENTA}Here are your notes in $filepath:${RESET}"
            if [ ! -s "$filepath" ]; then
                echo -e "${YELLOW}(No notes found in $filepath)${RESET}"
            else
                nl "$filepath"
            fi
        ;;
        
        3)
            choose_category || continue
            read -p "Enter the note number to delete: " num
            backup_notes "$filepath"
            sed -i "${num}d" "$filepath"
            echo -e "${GREEN}Note #$num deleted from $filepath (backup created).${RESET}"
        ;;
        
        4)
            read -p "Enter keyword to search: " keyword
            echo -e "${MAGENTA}Search results for '$keyword':${RESET}"
            grep --color=always -i "$keyword" notes/*.txt || echo -e "${YELLOW}No matches found.${RESET}"
        ;;
        
        5)
            if ! command -v fzf &>/dev/null; then
                echo -e "${RED}fzf not installed. Run: sudo apt install fzf${RESET}"
                continue
            fi
            
            SELECTED_FILE=$(find notes/ -type f | fzf)
            
            if [ -n "$SELECTED_FILE" ]; then
                clear
                echo -e "${GREEN}--- Viewing: $SELECTED_FILE ---${RESET}"
                cat "$SELECTED_FILE"
                echo ""
                read -p "Press enter to return to menu"
            else
                echo -e "${RED}No file selected.${RESET}"
            fi
        ;;
        
        6)
            choose_category || continue
            read -p "Enter the note number to edit: " num
            current=$(sed -n "${num}p" "$filepath")
            echo "Current line: $current"
            read -p "Enter new content: " new
            backup_notes "$filepath"
            sed -i "${num}s/.*/$new/" "$filepath"
            echo -e "${GREEN}Line #$num updated in $filepath (backup created).${RESET}"
        ;;
        
        7)
            today=$(date +%Y-%m-%d)
            filepath="notes/journal-$today.txt"
            echo -e "${CYAN}Writing to journal: $filepath${RESET}"
            echo "----- Journal entry on $(date) -----" >> "$filepath"
            cat >> "$filepath"
            echo "" >> "$filepath"
            echo -e "${GREEN}Entry saved to $filepath${RESET}"
        ;;
        
        8)
            read -p "Enter tag to search (include #): " tag
            echo -e "${MAGENTA}Searching for notes with tag '$tag':${RESET}"
            grep --color=always -r "$tag" notes/ || echo -e "${YELLOW}No notes found with tag $tag.${RESET}"
            read -p "Press enter to return to menu"
        ;;
        
        9)
            echo -e "${MAGENTA}Goodbye!${RESET}"
            break
        ;;
        
        *)
            echo -e "${RED}Invalid option. Try again.${RESET}"
        ;;
    esac
done
