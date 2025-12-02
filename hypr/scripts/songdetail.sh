#!/bin/bash

# Check if playerctl is running/installed
if ! command -v playerctl &> /dev/null; then
    echo ""
    exit 1
fi

# Get the status (Playing/Paused/Stopped)
status=$(playerctl status 2>/dev/null)

# Only print output if music is actually playing or paused
if [[ "$status" == "Playing" ]] || [[ "$status" == "Paused" ]]; then
    
    # Get metadata
    title=$(playerctl metadata title 2>/dev/null)
    artist=$(playerctl metadata artist 2>/dev/null)

    # Combine them
    text="$title • $artist"

    # Define the max length of characters before cutting it off
    max_length=45

    # Truncate if too long
    if [ ${#text} -gt $max_length ]; then
        text="$(echo "$text" | cut -c 1-$max_length)..."
    fi

    # Output with a music note icon (Nerd Font)
    # You can change " " to " " if you prefer the Spotify icon
    echo "  $text"
else
    # If nothing is playing, print nothing so the widget hides
    echo "" 
fi
