#!/bin/bash
# Organization: Greyway.Co | Device: Gionee SWW1617
# Targeted Hotspot Manager

SERIAL="PBHUMFR8KBMRSSVW"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GNIREHTET_BIN="$SCRIPT_DIR/gnirehtet"
ADB_BIN="${ADB_BIN:-/usr/bin/adb}"

if [ ! -x "$ADB_BIN" ]; then
	echo "Missing adb at $ADB_BIN" >&2
	exit 1
fi

echo "🧹 Cleaning up old sessions..."
pkill -f gnirehtet 2>/dev/null

echo "📱 Targeting Boss Device: $SERIAL"
# Targeted adb command ensures we only talk to your phone
"$ADB_BIN" -s "$SERIAL" wait-for-device

while true; do
	if ! "$ADB_BIN" -s "$SERIAL" devices | grep -q "device$"; then
		echo "❌ Boss Device disconnected. Stopping."
		exit 0
	fi
    
	# Run gnirehtet specifically for this serial
	"$GNIREHTET_BIN" run "$SERIAL"
	sleep 3
done
