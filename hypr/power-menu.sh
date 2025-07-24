#!/usr/bin/env bash

# Power menu script using wofi
# Options: Shutdown, Lock Screen, Cancel

# Show power menu options
selection=$(echo -e "🔴 Shutdown\n❌ Reboot\n🔒 Lock Screen\n❌ Cancel" | wofi --dmenu --prompt "Power Menu:" --width 300 --height 180)

# Exit if no selection or cancelled
if [[ -z "$selection" || "$selection" == "❌ Cancel" ]]; then
    exit 0
fi

# Execute selected action
case "$selection" in
    "🔴 Shutdown")
        shutdown 0
        ;;
    "❌ Reboot")
        reboot
        ;;
    "🔒 Lock Screen")
        hyprlock
        ;;
esac
