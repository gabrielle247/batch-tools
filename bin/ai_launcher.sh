#!/bin/bash

# --- PATHS ---
BIN_DIR="/home/nyashagabriel/build/bin"
CLI_RUNNER="$BIN_DIR/llama-cli"
SERVER_RUNNER="$BIN_DIR/llama-server"

MODEL_DIR="/home/nyashagabriel/Downloads"
QWEN="qwen2.5-coder-1.5b-instruct-q4_k_m.gguf"
DEEPSEEK="DeepSeek-R1-Distill-Qwen-1.5B-Q4_K_M.gguf"

# --- CONFIG ---
# Context size (how much code it remembers)
CTX="2048"

clear
echo "======================================"
echo "       AI MODEL LAUNCHER"
echo "======================================"
echo "1) Chat: Qwen 2.5 Coder (Terminal)"
echo "2) Chat: DeepSeek R1 (Terminal)"
echo "--------------------------------------"
echo "3) SERVER: Qwen 2.5 (For VS Code/Continue)"
echo "======================================"
read -p "Choose option: " choice

echo ""

case $choice in
    1)
        echo "Starting Qwen Chat..."
        "$CLI_RUNNER" -m "$MODEL_DIR/$QWEN" -c $CTX -cnv --color
        ;;
    2)
        echo "Starting DeepSeek Chat..."
        "$CLI_RUNNER" -m "$MODEL_DIR/$DEEPSEEK" -c $CTX -cnv --color
        ;;
    3)
        echo "Starting Qwen Server for VS Code..."
        echo "Server running at http://localhost:8080"
        echo "Keep this window OPEN while using VS Code."
        # --host 0.0.0.0 allows connections, --port 8080 is standard
        "$SERVER_RUNNER" -m "$MODEL_DIR/$QWEN" -c $CTX --port 8080 --host 0.0.0.0
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

echo ""
read -p "Press Enter to close..."
