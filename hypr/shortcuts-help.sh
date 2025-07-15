#!/usr/bin/env bash

# Hyprland shortcuts help script using wofi
# Shows all keybindings with descriptions

shortcuts="SUPER + Shift + H         → Show This Help
SUPER + Q                 → Open Terminal (Kitty)
SUPER + Shift + L         → Lock Screen
SUPER + Shift + A         → Audio Output Switcher
SUPER + Shift + P         → Project Launcher
SUPER + Ctrl + Shift + K  → Shutdown Computer
SUPER + Shift + F4        → Screenshot (Region)
SUPER + W                 → Kill Active Window
SUPER + M                 → Exit Hyprland
SUPER + R                 → Application Launcher (Wofi)
SUPER + H                 → Move Focus Left
SUPER + L                 → Move Focus Right  
SUPER + K                 → Move Focus Up
SUPER + J                 → Move Focus Down
SUPER + Y                 → Toggle Split Direction
SUPER + 1-0               → Switch to Workspace 1-10
SUPER + Shift + 1-0       → Move Window to Workspace 1-10
SUPER + S                 → Toggle Special Workspace
SUPER + Shift + S         → Move to Special Workspace
SUPER + LMB              → Move Window (Drag)
SUPER + RMB              → Resize Window (Drag)"

# Create temporary config for vim motions
temp_config=$(mktemp)
cat > "$temp_config" << EOF
key_up=Ctrl-k
key_down=Ctrl-j
key_pgup=Ctrl-u
key_pgdn=Ctrl-d
EOF

# Show shortcuts in wofi and capture selection
selected=$(echo -e "$shortcuts" | wofi --dmenu --prompt "Hyprland Shortcuts:" --width 500 --height 400 --cache-file /dev/null --insensitive --conf "$temp_config")

# Clean up temp file
rm -f "$temp_config"

# Exit if no selection
if [[ -z "$selected" ]]; then
    exit 0
fi

# Execute the selected shortcut
case "$selected" in
    *"Show This Help"*)
        ~/.config/hypr/shortcuts-help.sh
        ;;
    *"Open Terminal"*)
        kitty
        ;;
    *"Lock Screen"*)
        hyprlock
        ;;
    *"Audio Output Switcher"*)
        ~/.config/hypr/audio-switcher.sh
        ;;
    *"Project Launcher"*)
        ~/.config/hypr/project-launcher.sh
        ;;
    *"Shutdown Computer"*)
        ~/.config/hypr/shutdown.sh
        ;;
    *"Screenshot"*)
        hyprshot -m region --clipboard-only
        ;;
    *"Kill Active Window"*)
        hyprctl dispatch killactive
        ;;
    *"Exit Hyprland"*)
        hyprctl dispatch exit
        ;;
    *"Application Launcher"*)
        wofi --show drun
        ;;
    *"Toggle Split Direction"*)
        hyprctl dispatch togglesplit
        ;;
    *"Toggle Special Workspace"*)
        hyprctl dispatch togglespecialworkspace magic
        ;;
    *"Move to Special Workspace"*)
        hyprctl dispatch movetoworkspace special:magic
        ;;
esac
