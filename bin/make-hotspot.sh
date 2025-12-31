#!/bin/bash
# Global wrapper script for gnirehtet hotspot
# Install in ~/.local/bin/ so it's available from anywhere

GNIREHTET_DIR="/home/nyashagabriel/Downloads/gnirehtet-rust-linux64"

if [[ ! -d "$GNIREHTET_DIR" ]]; then
    echo "Error: Gnirehtet directory not found at $GNIREHTET_DIR"
    exit 1
fi

cd "$GNIREHTET_DIR" && make hotspot
