#!/bin/bash

# --- SMART VIDEO REPAIR FOR NYASHA GABRIEL ---
# Automatically finds a working video to use as a reference
# and repairs the broken footage.

TARGET_DIR="/home/nyashagabriel/Videos/Informatics_Olympiad_Project/01_RawFootage"
cd "$TARGET_DIR" || { echo "Directory not found!"; exit 1; }

echo "--- 1. Searching for a working reference video ---"

# We need to find ONE video file that is NOT broken to use as a key.
REFERENCE_FILE=""

# Loop through all MP4s to find a valid one
for f in *.mp4; do
    # Check if this file is valid using ffprobe (part of ffmpeg)
    # If ffprobe returns 0, the file is good.
    if ffprobe -v error "$f" >/dev/null 2>&1; then
        echo "✅ Found valid video: $f"
        REFERENCE_FILE="$f"
        break
    fi
done

if [ -z "$REFERENCE_FILE" ]; then
    echo "❌ ERROR: No working video found!"
    echo "Please make sure you have transferred the short 10-second video from your phone to this folder."
    echo "Current files in folder:"
    ls -lh *.mp4
    exit 1
fi

echo "Using '$REFERENCE_FILE' to fix your broken files..."
echo "---------------------------------------------------"

# --- 2. REPAIR PROCESS ---
for broken in *.mp4; do
    # Skip the reference file itself
    if [ "$broken" == "$REFERENCE_FILE" ]; then continue; fi
    
    # Skip files that look like they are already fixed
    if [[ "$broken" == *"_fixed.mp4"* ]]; then continue; fi

    # Check if file is actually broken using ffprobe
    if ! ffprobe -v error "$broken" >/dev/null 2>&1; then
        echo "🔧 Repairing broken file: $broken"
        
        # Run untrunc
        if untrunc "$REFERENCE_FILE" "$broken"; then
            echo "✅ SUCCESS: Saved as ${broken}_fixed.mp4"
        else
            echo "❌ FAILED: Could not repair $broken"
        fi
        echo "--------------------------------"
    else
        echo "👍 Skipping $broken (It is already a healthy file)"
    fi
done

echo "--- Done! Check for _fixed.mp4 files ---"
