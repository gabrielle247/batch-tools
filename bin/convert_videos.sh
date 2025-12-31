#!/bin/bash

# Define the directory containing the videos
# Change this path to your actual video directory
VIDEO_DIR="./your_video_folder"

# Define the output format (MOV with H.264 codec is widely compatible and editable)
OUTPUT_EXT="mov"
CODEC_V="libx264"
CODEC_A="aac"

# Create an output directory
OUTPUT_DIR="${VIDEO_DIR}/converted_for_editing"
mkdir -p "$OUTPUT_DIR"

# 1. Check and Install FFmpeg
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg is not installed. Attempting to install..."
    # Update package lists and install ffmpeg (requires sudo password)
    sudo apt update && sudo apt install ffmpeg -y
    if [ $? -eq 0 ]; then
        echo "ffmpeg installed successfully."
    else
        echo "Failed to install ffmpeg. Please install it manually and run the script again."
        exit 1
    fi
else
    echo "ffmpeg is already installed."
fi

# 2. Convert all videos in the specified directory
echo "Starting video conversion in $VIDEO_DIR..."

# Loop through all files in the directory (adjust extensions as needed, e.g., *.mp4 *.avi)
for f in "$VIDEO_DIR"/*; do
    # Check if it is a file and not a directory
    if [ -f "$f" ]; then
        filename=$(basename -- "$f")
        extension="${filename##*.}"
        filename="${filename%.*}"
        output_file="$OUTPUT_DIR/${filename}.${OUTPUT_EXT}"

        echo "Converting '$f' to '$output_file'..."
        ffmpeg -i "$f" -c:v "$CODEC_V" -preset medium -crf 18 -c:a "$CODEC_A" -b:a 192k -strict experimental "$output_file"
        echo "Finished converting '$filename'."
    fi
done

echo "All conversions complete. Files are located in '$OUTPUT_DIR'."

