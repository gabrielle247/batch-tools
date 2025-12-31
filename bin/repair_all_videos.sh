#!/bin/bash

# --- VIDEO REPAIR AUTOMATION FOR NYASHA GABRIEL ---
# This script uses 'untrunc' to fix corrupt MP4 files by using a 
# working 'reference.mp4' from the same camera.

# Directory Setup
TARGET_DIR="/home/nyashagabriel/Videos/Informatics_Olympiad_Project/01_RawFootage"
cd "$TARGET_DIR" || { echo "Error: Could not find directory $TARGET_DIR"; exit 1; }

# Reference File Check
REFERENCE="reference.mp4"
if [ ! -f "$REFERENCE" ]; then
    echo "❌ ERROR: 'reference.mp4' is missing!"
    echo "PLEASE DO THIS:"
    echo "1. Record a short 10-second video on your Pixel phone."
    echo "2. Place it in this folder: $TARGET_DIR"
    echo "3. Rename it to 'reference.mp4'"
    exit 1
fi

echo "--- Starting Repair Process ---"

# Loop specifically through the PXL files you listed earlier
for broken_file in PXL_*.mp4; do
    
    # Skip the reference file itself or already fixed files
    if [[ "$broken_file" == "reference.mp4" ]] || [[ "$broken_file" == *"_fixed.mp4"* ]]; then
        continue
    fi

    # Check if this specific file has already been fixed
    fixed_name="${broken_file}_fixed.mp4"
    if [ -f "$fixed_name" ]; then
        echo "⚠️  Skipping $broken_file (Fixed version already exists)"
        continue
    fi

    echo "🔧 Attempting to fix: $broken_file"
    
    # Execute Untrunc
    # Syntax: untrunc [good_file] [bad_file]
    if untrunc "$REFERENCE" "$broken_file"; then
        echo "✅ SUCCESS: Saved as $fixed_name"
    else
        echo "❌ FAILED: Could not repair $broken_file"
    fi
    echo "---------------------------------------------------"
done

echo "--- Operation Complete ---"
echo "If successful, you can now run your original conversion script on the '_fixed.mp4' files."
