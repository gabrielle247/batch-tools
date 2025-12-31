#!/bin/bash
set -e

# Arguments
INPUT_NAME="$1"  # This can be a name, a rough path, or a full path
TARGET_TYPE="$2" # obb, data, or media

# --- 1. SETUP ---
echo "--- Greyway.Co Deep Search Mover ---"

# Connect
if ! adb get-state 1>/dev/null 2>&1; then
    echo "⚠️  Waiting for device..."
    adb wait-for-device
fi
adb root > /dev/null 2>&1 || true 
sleep 0.5

# Define Destination
case "$TARGET_TYPE" in
    obb)   DST="/sdcard/Android/obb" ;;
    data)  DST="/sdcard/Android/data" ;;
    media) DST="/sdcard/Android/media" ;;
    *)     echo "❌ Unknown type: $TARGET_TYPE"; exit 1 ;;
esac

# --- 2. INTELLIGENT SEARCH ---

# Clean the input (remove trailing slashes)
CLEAN_INPUT=${INPUT_NAME%/}
# Extract just the name in case user pasted a long path
SEARCH_TERM=$(basename "$CLEAN_INPUT")

echo "🔎 Input received: '$INPUT_NAME'"
echo "   Checking if exact path exists..."

# A. Try Exact Match First
IS_EXACT=$(adb shell "if [ -e '$INPUT_NAME' ]; then echo yes; else echo no; fi")

if [ "$IS_EXACT" = "yes" ]; then
    FULL_SRC="$INPUT_NAME"
    echo "✅ Exact match found."
else
    # B. Try "Smart Search" (Find matches anywhere in /sdcard)
    echo "⚠️  Exact path not found."
    echo "🕵️  Searching entire /sdcard for '$SEARCH_TERM'..."
    
    # Search for files or folders with the name, ignoring case (-iname is not always avail in adb, using -name)
    # We grep to filter out empty lines
    mapfile -t MATCHES < <(adb shell "find /sdcard -name '*$SEARCH_TERM*' -maxdepth 4 2>/dev/null")

    COUNT=${#MATCHES[@]}

    if [ "$COUNT" -eq 0 ]; then
        echo "❌ No matches found for '$SEARCH_TERM' on the device."
        exit 1
    elif [ "$COUNT" -eq 1 ]; then
        # Only one match found, auto-select it? No, ask for confirmation to be safe.
        FULL_SRC="${MATCHES[0]}"
        echo "✅ Found 1 match: $FULL_SRC"
    else
        # Multiple matches found
        echo "🤔 Found $COUNT matches. Which one did you mean?"
        echo "------------------------------------------------"
        i=1
        for item in "${MATCHES[@]}"; do
            echo " $i) $item"
            ((i++))
        done
        echo "------------------------------------------------"
        
        read -p "Select a number: " SELECTION
        
        if [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ "$SELECTION" -le "$COUNT" ] && [ "$SELECTION" -gt 0 ]; then
            INDEX=$((SELECTION-1))
            FULL_SRC="${MATCHES[$INDEX]}"
        else
            echo "❌ Invalid selection."
            exit 1
        fi
    fi
fi

# --- 3. EXECUTE MOVE ---
echo "🚀 Moving: $FULL_SRC"
echo "➡️  To:     $DST"

# Verify source one last time
CHECK_SRC=$(adb shell "if [ -e '$FULL_SRC' ]; then echo yes; else echo no; fi")
if [ "$CHECK_SRC" = "no" ]; then
    echo "❌ System Error: Source path invalid."
    exit 1
fi

adb shell "mkdir -p '$DST' && mv '$FULL_SRC' '$DST/'"

echo "✅ Success. Files moved."
