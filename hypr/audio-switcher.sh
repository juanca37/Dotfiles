#!/usr/bin/env bash

# Audio Output Device Switcher using wofi
# Requires: wpctl (wireplumber), wofi

# Get list of audio sinks (output devices)
get_audio_sinks() {
    wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep -E "^\s*│\s*[\*]*\s*[0-9]+\." | while read -r line; do
        # Extract device ID (the number before the dot)
        device_id=$(echo "$line" | grep -o '[0-9]\+' | head -1)
        
        # Extract device name (everything after the number and dot, before any brackets)
        device_name=$(echo "$line" | sed 's/^[^0-9]*[0-9]\+\.\s*//' | sed 's/\s*\[.*$//')
        
        # Check if this is the default device (has asterisk)
        if echo "$line" | grep -q "\*"; then
            echo "🔊 $device_name [$device_id] (current)"
        else
            echo "🔇 $device_name [$device_id]"
        fi
    done
}

# Show wofi menu and get selection
selected=$(get_audio_sinks | wofi --dmenu --prompt "Select Audio Output:" --width 400 --height 300)

# Exit if nothing selected
if [[ -z "$selected" ]]; then
    exit 0
fi

# Extract device ID from selection
device_id=$(echo "$selected" | grep -o '\[[0-9]\+\]' | tr -d '[]')

if [[ -n "$device_id" ]]; then
    # Set the selected device as default
    wpctl set-default "$device_id"
    
    # Get device name for notification
    device_name=$(echo "$selected" | sed 's/🔊\|🔇//' | sed 's/\s*\[.*\].*//' | sed 's/^\s*//')
    
    # Show notification (if notify-send is available)
    if command -v notify-send &> /dev/null; then
        notify-send "Audio Output" "Switched to: $device_name" -i audio-speakers
    fi
else
    # Show error notification
    if command -v notify-send &> /dev/null; then
        notify-send "Audio Error" "Could not switch audio device" -i dialog-error
    fi
fi
