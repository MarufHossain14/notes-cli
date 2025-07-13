#!/bin/bash

backup_notes() {
    cp notes.txt "notes_backup_$(date +%Y%m%d_%H%M%S).txt"
}

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"


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
            echo "Write your note below (press CTRL+D when done):"
            echo "-----Note taken on $(date) -----" >> notes.txt
            cat >> notes.txt
            echo -e "${GREEN}Note saved!${RESET}"

            ;;
        2)
            echo "Here are your notes:"
            nl notes.txt
            ;;
        3)
    read -p "Enter the note number to delete: " num
    backup_notes
    sed -i "${num}d" notes.txt
    echo -e "${GREEN}Note #$num deleted (backup created).${RESET}"

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
