#!/usr/bin/env bash
set -euo pipefail

# Attempt to locate and remove old PowerSync DB files used before schema versioning.
# This reclaims space and ensures no stale local stores remain.

# Common locations for Flutter Linux app documents directory.
CANDIDATES=(
  "$HOME/.local/share/fees_up/fees_up.db"
  "$HOME/.local/share/Fees Up/fees_up.db"
  "$HOME/.config/fees_up/fees_up.db"
)

FOUND=0
for p in "${CANDIDATES[@]}"; do
  if [[ -f "$p" ]]; then
    echo "Found old DB: $p"
    rm -f "$p"
    echo "Removed: $p"
    FOUND=1
  fi
done

if [[ "$FOUND" -eq 0 ]]; then
  echo "No old PowerSync DB files found in common locations."
fi

echo "Done."