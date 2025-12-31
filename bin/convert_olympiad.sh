#!/bin/bash

# --- INSTALLATION CHECK ---
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg not found. Installing..."
    sudo apt update && sudo apt install ffmpeg -y
fi

# --- CONFIGURATION ---
# The path you provided
TARGET_DIR="/home/nyashagabriel/Videos/Informatics_Olympiad_Project/01_RawFootage"
OUTPUT_DIR="$TARGET_DIR/Converted_For_Editing"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Move into the target directory
cd "$TARGET_DIR" || { echo "Directory not found!"; exit 1; }

# --- CONVERSION LOOP ---
shopt -s nocaseglob  # Catch .MP4 and .mp4
for f in *.{mp4,mov,mkv,avi,m4v}; do
    [ -e "$f" ] || continue
    
    filename=$(basename -- "$f")
    name="${filename%.*}"
    
    echo "--- Processing: $filename ---"
    
    # Converts to ProRes 422 (Standard editing format)
    # Using pcm_s16le for uncompressed audio to avoid sync issues
    ffmpeg -ignore_editlist 1 -err_detect ignore_err -i "$f" \
           -c:v prores_ks -profile:v 3 \
           -c:a pcm_s16le \
           "$OUTPUT_DIR/${name}_editable.mov" -y

done

echo "Done! All files are in: $OUTPUT_DIR"

