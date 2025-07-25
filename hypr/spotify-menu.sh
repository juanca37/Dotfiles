#!/usr/bin/env bash

# Spotify (ncspot) wofi menu

choice=$(echo -e "Show/Hide ncspot\nPlay/Pause\nNext\nPrevious" | wofi --dmenu --prompt "Spotify" --height 200)

case "$choice" in
    "Show/Hide ncspot")
        if ! pgrep -x ncspot > /dev/null; then
            kitty -e ncspot &
            sleep 0.3
        fi
        ncspot_win=$(hyprctl clients -j | jq -r '.[] | select(.class == "kitty" and .title == "ncspot") | .address' | head -n1)
        if [ -n "$ncspot_win" ]; then
            # Get current window position
            read win_x win_y <<< $(hyprctl clients -j | jq -r --arg addr "$ncspot_win" '.[] | select(.address == $addr) | "\(.at[0]) \(.at[1])"')
            # Get screen size
            read sw sh <<< $(hyprctl monitors -j | jq -r '.[0] | "\(.width) \(.height)"')
            # Calculate 50% size and position
            w=$((sw/2))
            h=$((sh/2))
            x=$(( (sw-w)/2 ))
            y=$(( (sh-h)/2 ))
            # Get current workspace of ncspot
            ncspot_ws=$(hyprctl clients -j | jq -r --arg addr "$ncspot_win" '.[] | select(.address == $addr) | .workspace.id')
            ws=$(hyprctl activeworkspace -j | jq -r '.id')
            # Only hide if window is centered AND on current workspace
            if [ "$win_x" = "$x" ] && [ "$win_y" = "$y" ] && [ "$ncspot_ws" = "$ws" ]; then
                hyprctl dispatch movewindowpixel exact $((sw+100)) $((sh+100)),address:$ncspot_win
            else
                hyprctl dispatch movetoworkspace $ws,address:$ncspot_win
                hyprctl dispatch setfloating address:$ncspot_win
                hyprctl dispatch resizewindowpixel exact $w $h,address:$ncspot_win
                hyprctl dispatch movewindowpixel exact $x $y,address:$ncspot_win
                hyprctl dispatch bringactivetotop address:$ncspot_win
                hyprctl dispatch focuswindow address:$ncspot_win
            fi
        fi
        ;;
    "Play/Pause")
        playerctl -p ncspot play-pause
        ;;
    "Next")
        playerctl -p ncspot next
        ;;
    "Previous")
        playerctl -p ncspot previous
        ;;
    # Show/Hide ncspot option removed
    *)
        exit 0
        ;;
esac
