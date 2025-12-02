#!/bin/bash

art_path="/tmp/album_art.jpg"
url=$(playerctl metadata mpris:artUrl 2>/dev/null)

# 1. If no song/url is found, remove the file so the image widget hides
if [[ -z "$url" ]]; then
  rm -f "$art_path"
  echo "" # Tell Hyprlock there is no image
  exit
fi

# 2. Check if the image source actually changed to avoid re-downloading every second (Optional optimization)
#    For now, we simply overwrite to ensure it stays in sync.

if [[ "$url" == http* ]]; then
  # Download and convert to High Quality JPG
  curl -s -o "/tmp/temp_art_download" "$url"
  magick "/tmp/temp_art_download" -quality 100 "$art_path"
  rm -f "/tmp/temp_art_download"

elif [[ "$url" == file://* ]]; then
  local_path="${url#file://}"

  # Convert local file to High Quality JPG
  if command -v magick &>/dev/null; then
    magick "$local_path" -quality 100 "$art_path"
  else
    convert "$local_path" -quality 100 "$art_path"
  fi
fi

# 3. CRITICAL STEP: Echo the path so Hyprlock knows to reload it
if [[ -f "$art_path" ]]; then
  echo "$art_path"
fi
