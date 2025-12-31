#!/bin/bash

# ==========================================
# Greyway.Co / Batch Tech Image Downloader
# ==========================================

# 1. SETUP: Define your download directory
DOWNLOAD_DIR="./downloaded_images"

# 2. INPUT: Paste your image URLs here inside the parentheses
#    Separate URLs with spaces or new lines.
IMAGE_URLS=(
    https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.redbubble.com%2Fi%2Fsticker%2FNagatoro-by-superturret%2F35277588.EJUG5&ved=0CBUQjRxqFwoTCNCKyPCxwZEDFQAAAAAdAAAAABA6&opi=89978449
    
)

# ==========================================
# LOGIC START
# ==========================================

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "Error: 'wget' is not installed."
    echo "Please install it using: sudo apt install wget"
    exit 1
fi

# Create the directory if it doesn't exist
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Creating directory: $DOWNLOAD_DIR"
    mkdir -p "$DOWNLOAD_DIR"
else
    echo "Saving to existing directory: $DOWNLOAD_DIR"
fi

echo "------------------------------------------"
echo "Starting Batch Download..."
echo "Total images to download: ${#IMAGE_URLS[@]}"
echo "------------------------------------------"

# Loop through the array and download
count=1
for url in "${IMAGE_URLS[@]}"; do
    echo "[$count/${#IMAGE_URLS[@]}] Downloading: $url"
    
    # -P specifies the directory prefix
    # -q shows less output (quiet), --show-progress shows the bar
    # -nc skips download if file already exists (no-clobber)
    wget -P "$DOWNLOAD_DIR" -q --show-progress -nc "$url"

    if [ $? -eq 0 ]; then
        echo " -> Success"
    else
        echo " -> Failed to download: $url"
    fi
    
    ((count++))
done

echo "------------------------------------------"
echo "Job Complete. Check the '$DOWNLOAD_DIR' folder."
echo "------------------------------------------"
