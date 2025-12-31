#!/bin/bash

# --- EMERGENCY DEEP SEARCH REPAIR ---
# Scans user's video folders for a working file to use as a 'Key'
# to unlock the broken footage.

BROKEN_DIR="/home/nyashagabriel/Videos/Informatics_Olympiad_Project/01_RawFootage"
SEARCH_ROOT="/home/nyashagabriel/Videos"

echo "--- 1. Hunting for a 'Key' (Valid Reference Video) ---"
echo "Searching in: $SEARCH_ROOT"

REFERENCE_KEY=""

# Find all mp4 files, sort by date (newest first might be closer in settings)
# process loop
while IFS= read -r candidate; do
    # Skip the known broken files
    if [[ "$candidate" == *"/01_RawFootage/PXL_"* ]]; then continue; fi
    
    # Check if this candidate is a healthy video
    if ffprobe -v error "$candidate" >/dev/null 2>&1; then
        echo "✅ FOUND POTENTIAL KEY: $candidate"
        REFERENCE_KEY="$candidate"
        break # Stop after finding the first valid one to save time
    fi
done < <(find "$SEARCH_ROOT" -name "*.mp4")

if [ -z "$REFERENCE_KEY" ]; then
    echo "❌ CRITICAL FAILURE: No working MP4 files found in your Videos folder."
    echo "I cannot repair the files without a generic template."
    echo "YOU MUST record a 5-second video on your phone and put it in $BROKEN_DIR"
    exit 1
fi

echo "--- 2. Attempting Repair using Key: $(basename "$REFERENCE_KEY") ---"
cd "$BROKEN_DIR" || exit 1

for broken in PXL_*.mp4; do
    # Skip if already fixed
    if [[ "$broken" == *"_fixed.mp4"* ]]; then continue; fi

    echo ">> Fixing $broken..."
    
    # Run repair
    if untrunc "$REFERENCE_KEY" "$broken"; then
        echo "✅ SAVED: ${broken}_fixed.mp4"
    else
        echo "⚠️  Failed to fix $broken with this key."
    fi
done
