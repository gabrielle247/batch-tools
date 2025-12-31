#!/usr/bin/env bash

# Where the Dart files live
SRC="lib"

# Where you want the list saved
DEST="$HOME/Desktop"

# Find the next free version number
ver=1
while [[ -e "$DEST/version_$ver.txt" ]]; do
    ((ver++))
done
OUT="$DEST/version_$ver.txt"

# Collect the paths (one per line) and save
find "$SRC" -type f -name "*.dart" > "$OUT"

echo "Saved $(wc -l < "$OUT") Dart files to $OUT"
