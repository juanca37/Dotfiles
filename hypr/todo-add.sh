#!/usr/bin/env bash

# TODO manager script - Add or view tasks via wofi
# Usage: todo-add.sh [add|view]

TODO_FILE="$HOME/.todo-list.txt"

# Function to add a new TODO task

add_todo() {
    # Use wl-paste to get clipboard content for pre-fill
    selected_text=""
    if command -v wl-paste &>/dev/null; then
        selected_text=$(wl-paste 2>/dev/null)
    fi
    echo "Clipboard content: '$selected_text'"

    # Prompt for TODO task using wofi, pre-filled if clipboard exists
    if [[ -n "$selected_text" ]]; then
        task=$(printf "%s" "$selected_text" | wofi --dmenu --prompt "TODO task:" --height 100)
    else
        task=$(wofi --dmenu --prompt "TODO task:" --height 100 < /dev/null)
    fi

    # If no task entered or cancelled, exit
    if [[ -z "$task" ]]; then
        exit 0
    fi

    # Add task with timestamp to file
    echo "$task|$(date '+%Y-%m-%d %H:%M:%S')" >> "$TODO_FILE"
}

# Function to view all TODO tasks
view_todos() {
    # Check if TODO file exists
    if [[ ! -f "$TODO_FILE" ]]; then
        echo "No TODO file found" | wofi --dmenu --prompt "No TODOs" --height 100
        exit 0
    fi

    # Check if file is empty
    if [[ ! -s "$TODO_FILE" ]]; then
        echo "TODO file is empty" | wofi --dmenu --prompt "No TODOs" --height 100
        exit 0
    fi

    # Only show non-DONE tasks, with [CURRENT] at the top
    current=$(grep '^\[CURRENT\]' "$TODO_FILE")
    rest=$(grep -v '^\[CURRENT\]' "$TODO_FILE" | grep -v '^\[DONE')
    if [[ -n "$current" ]]; then
        todo_menu=$(printf "%s\n%s" "$current" "$rest")
    else
        todo_menu="$rest"
    fi

    # Display all TODO tasks in wofi and get selection
    selected=$(printf "%s" "$todo_menu" | wofi --dmenu --prompt "TODO List:" --height 300)
    
    # If nothing selected, exit
    if [[ -z "$selected" ]]; then
        return
    fi

    # Remove [CURRENT] from all lines first
    sed -i 's/\[CURRENT\] //' "$TODO_FILE"

    if [[ "$selected" =~ ^\[CURRENT\] ]]; then
        # If selected is CURRENT, mark as DONE with timestamp
        done_line="[DONE $(date '+%Y-%m-%d %H:%M:%S')] ${selected#\[CURRENT\] }"
        # Remove the selected line and append as DONE
        grep -v "^\[CURRENT\] $(echo "${selected#\[CURRENT\] }" | sed 's/[[\.*^$()+?{|]/\\&/g')$" "$TODO_FILE" > "$TODO_FILE.tmp"
        mv "$TODO_FILE.tmp" "$TODO_FILE"
        echo "$done_line" >> "$TODO_FILE"
    else
        # Mark selected as CURRENT and move to top
        temp_file=$(mktemp)
        echo "[CURRENT] $selected" > "$temp_file"
        grep -v "^$(echo "$selected" | sed 's/[[\.*^$()+?{|]/\\&/g')$" "$TODO_FILE" >> "$temp_file"
        mv "$temp_file" "$TODO_FILE"
    fi
}

# Main logic - check command line argument
case "${1:-add}" in
    "add")
        add_todo
        ;;
    "view")
        view_todos
        ;;
    *)
        echo "Usage: $0 [add|view]"
        exit 1
        ;;
esac
