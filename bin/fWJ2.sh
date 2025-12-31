#!/bin/bash
# Organization: Greyway.Co | Device: Gionee SWW1617
# Targeted Hotspot Manager

SERIAL="PBHUMFR8KBMRSSVW"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GNIREHTET_BIN="$SCRIPT_DIR/gnirehtet"

echo "🧹 Cleaning up old sessions..."
pkill -f gnirehtet 2>/dev/null

echo "📱 Targeting Boss Device: $SERIAL"
# Targeted adb command ensures we only talk to your phone
adb -s "$SERIAL" wait-for-device

while true; do
	if ! adb -s "$SERIAL" devices | grep -q "device$"; then
		echo "❌ Boss Device disconnected. Stopping."
		exit 1
	fi
    
	# Run gnirehtet specifically for this serial
	"$GNIREHTET_BIN" run "$SERIAL"
	sleep 3
done
