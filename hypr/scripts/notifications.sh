#!/bin/bash

# Check for SwayNC
if ! command -v swaync-client &> /dev/null; then
    echo ""
    exit
fi

# Get Count
count=$(swaync-client -c)

# If 0, print nothing and exit (hides the widget)
if [ "$count" -eq 0 ]; then
    echo ""
    exit
fi

# Get Latest Notification (requires jq)
# This extracts the App Name and Summary of the latest notification
latest=$(swaync-client -j | jq -r '. | to_entries | sort_by(.key) | last | .value | .app_name + ": " + .summary' 2>/dev/null)

# Truncate if too long (max 50 chars)
if [ ${#latest} -gt 50 ]; then
    latest="$(echo "$latest" | cut -c 1-50)..."
fi

# Output: Icon + Count + Latest Text
echo "  $count  |  $latest"
