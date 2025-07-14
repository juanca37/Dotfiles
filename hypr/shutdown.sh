#!/usr/bin/env bash

# Shutdown script using wofi for confirmation
# Requires: wofi

# Show confirmation dialog
confirmation=$(echo -e "🔴 Shutdown Now\n❌ Cancel" | wofi --dmenu --prompt "Confirm shutdown:" --width 300 --height 115)

# Exit if no selection or cancelled
if [[ -z "$confirmation" || "$confirmation" == "❌ Cancel" ]]; then
    exit 0
fi

# Shutdown if confirmed
if [[ "$confirmation" == "🔴 Shutdown Now" ]]; then
    shutdown 0
fi
