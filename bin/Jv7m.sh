#!/bin/bash
# Gnirehtet hotspot with auto-restart on disconnect

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GNIREHTET_BIN="$SCRIPT_DIR/gnirehtet"

# Check if gnirehtet binary exists
if [[ ! -f "$GNIREHTET_BIN" ]]; then
    echo "Error: gnirehtet binary not found at $GNIREHTET_BIN"
    exit 1
fi

echo "🚀 Starting Gnirehtet Hotspot (will auto-restart on disconnect)..."
echo "Press Ctrl+C to stop"

# Infinite loop for auto-restart
while true; do
    "$GNIREHTET_BIN" run
    EXIT_CODE=$?
    
    if [[ $EXIT_CODE -eq 0 ]]; then
        echo "✓ Gnirehtet exited normally"
        break
    else
        echo "⚠️  Connection disconnected (exit code: $EXIT_CODE). Restarting in 3 seconds..."
        sleep 3
    fi
done

echo "✓ Gnirehtet hotspot stopped"
