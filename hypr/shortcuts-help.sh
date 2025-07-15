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

# Show shortcuts in wofi
echo -e "$shortcuts" | wofi --dmenu --prompt "Hyprland Shortcuts:" --width 500 --height 400 --cache-file /dev/null
