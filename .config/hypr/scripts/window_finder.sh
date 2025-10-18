#!/usr/bin/env sh

clients=$(hyprctl -j clients )
# Select by title only
# window_title="$(echo "$clients" | jq -r '.[] | .title' | sort -u | rofi -dmenu -i -p "Select Window")"
# Alternative if i want to see by class too
window_title="$(echo "$clients" | jq -r '.[] | .class + " -> " + .title' | sort -u | rofi -dmenu -i -p "Select Window")"
window_title=${window_title#*-> }
window_address=$(echo "$clients" | jq -r --arg TITLE "$window_title" '.[] | select(.title == $TITLE) | .address')

echo "$window_address" | xargs -I {} hyprctl dispatch focuswindow "address:{}"
