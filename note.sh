#!/bin/bash

if [ "$1" == "list" ]; then
    echo "Here are your notes:"
    nl notes.txt
else
    echo "Write your note below (press CTRL+D when done):"
    cat >> notes.txt
    echo "Your note has been saved!"
fi
