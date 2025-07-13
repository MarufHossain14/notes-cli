#!/bin/bash

backup_notes() {
    cp notes.txt "notes_backup_$(date +%Y%m%d_%H%M%S).txt"
}


while true; do
    echo ""
    echo "What would you like to do?"
    echo "1. Add a note"
echo "2. List notes"
echo "3. Delete a note"
echo "4. Search notes"
echo "5. Edit a note"
echo "6. Exit"

    read -p "Enter choice [1-6]: " choice

    case $choice in
        1)
            echo "Write your note below (press CTRL+D when done):"
            echo "-----Note taken on $(date) -----" >> notes.txt
            cat >> notes.txt
            echo "Note saved!"
            ;;
        2)
            echo "Here are your notes:"
            nl notes.txt
            ;;
        3)
    read -p "Enter the note number to delete: " num
    backup_notes
    sed -i "${num}d" notes.txt
    echo "Note #$num deleted (backup created)."
    ;;

        4)
    read -p "Enter keyword to search: " keyword
    echo "Search results for '$keyword':"
    grep --color=always -i "$keyword" notes.txt || echo "No matches found."
    ;;

       5)
    read -p "Enter the note number to edit: " num
    current=$(sed -n "${num}p" notes.txt)
    echo "Current line: $current"
    read -p "Enter new content: " new
    backup_notes
    sed -i "${num}s/.*/$new/" notes.txt
    echo "Line #$num updated (backup created)."
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
