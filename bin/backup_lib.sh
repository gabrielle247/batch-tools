#!/usr/bin/env bash
set -euo pipefail

# Destination folder (override with BACKUP_DST)
DST_BASE="${BACKUP_DST:-$HOME/Desktop/backups/fees_up}"
TS=$(date -u +'%Y-%m-%dT%H-%M-%SZ')
DST_DIR="$DST_BASE/$TS"

mkdir -p "$DST_DIR"
cp -a lib "$DST_DIR/"
COUNT=$(find "$DST_DIR/lib" -type f | wc -l | tr -d ' ')
{
  echo "snapshot: $TS"
  echo "source: $(pwd)/lib"
  echo "files: $COUNT"
} > "$DST_DIR/manifest.txt"

ln -sfn "$TS" "$DST_BASE/latest"
echo "✅ Lib backup created at: $DST_DIR (files: $COUNT)"
