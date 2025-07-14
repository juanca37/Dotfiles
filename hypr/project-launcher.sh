#!/usr/bin/env bash

# Project launcher script using wofi in dmenu mode
# First selects project, then shows how to open it

# Get folders from ~/Configs and ~/Projects
configs_folders=$(find ~/Configs -maxdepth 1 -type d -not -path ~/Configs | sed 's|.*/||' | sed 's|^|📁 Configs/|')
projects_folders=$(find ~/Projects -maxdepth 1 -type d -not -path ~/Projects 2>/dev/null | sed 's|.*/||' | sed 's|^|🚀 Projects/|')

# Combine all folders
all_folders="$configs_folders"
if [ -n "$projects_folders" ]; then
    all_folders="$all_folders\n$projects_folders"
fi

# Exit if no folders found
if [ -z "$all_folders" ]; then
    echo "No folders found in ~/Configs or ~/Projects"
    exit 1
fi

# Show folder selection menu first
selected_folder=$(echo -e "$all_folders" | wofi --dmenu --prompt "Select project:" --width 400 --height 200 --insensitive)

# Exit if no folder was selected
if [ -z "$selected_folder" ]; then
    exit 0
fi

# Extract the actual folder path
if [[ "$selected_folder" == "📁 Configs/"* ]]; then
    folder_name=$(echo "$selected_folder" | sed 's/📁 Configs\///')
    folder_path="$HOME/Configs/$folder_name"
elif [[ "$selected_folder" == "🚀 Projects/"* ]]; then
    folder_name=$(echo "$selected_folder" | sed 's/🚀 Projects\///')
    folder_path="$HOME/Projects/$folder_name"
else
    exit 1
fi

# Define the editor/action options
action_options="💻 VSCode\n🔧 Nvim (Terminal)\n📺 Tmux Session\n📂 File Browser"

# Show action selection menu
selected_action=$(echo -e "$action_options" | wofi --dmenu --prompt "Open with:" --width 300 --height 200 --insensitive)

# Exit if no action was selected
if [ -z "$selected_action" ]; then
    exit 0
fi

# Execute based on action selection
case "$selected_action" in
    "💻 VSCode")
        code "$folder_path"
        ;;
    "🔧 Nvim (Terminal)")
        kitty sh -c "cd '$folder_path' && nvim"
        ;;
    "📺 Tmux Session")
        kitty sh -c "cd '$folder_path' && tmux new-session"
        ;;
    "📂 File Browser")
        # Use dolphin file manager
        dolphin "$folder_path"
        ;;
esac
