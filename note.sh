#!/bin/bash

backup_notes() {
    cp "$1" "notes/backup_$(basename "$1")_$(date +%Y%m%d_%H%M%S).txt"
}


# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"

mkdir -p notes

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


while true; do
    echo ""
    echo "What would you like to do?"
    echo -e "${CYAN}What would you like to do?${RESET}"
echo -e "${YELLOW}1.${RESET} Add a note"
echo -e "${YELLOW}2.${RESET} List notes"
echo -e "${YELLOW}3.${RESET} Delete a note"
echo -e "${YELLOW}4.${RESET} Search notes"
echo -e "${YELLOW}5.${RESET} Edit a note"
echo -e "${YELLOW}6.${RESET} Exit"


    read -p "Enter choice [1-6]: " choice

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
    nl "$filepath"
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
    grep --color=always -i "$keyword" notes.txt || echo "No matches found."
    ;;

       5)
    read -p "Enter the note number to edit: " num
    current=$(sed -n "${num}p" notes.txt)
    echo "Current line: $current"
    read -p "Enter new content: " new
    backup_notes
    sed -i "${num}s/.*/$new/" notes.txt
    echo -e "${GREEN}Line #$num updated (backup created).${RESET}"

    ;;

 
       6) 
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
