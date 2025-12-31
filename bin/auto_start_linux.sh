#!/bin/bash
# Fees-Up Auto-Launch Script for Linux
# This script automatically starts the Flutter app on Linux without user intervention

PROJECT_DIR="/home/nyashagabriel/Development/fees_up"
LOG_FILE="/tmp/fees_up_dev.log"
PID_FILE="/tmp/fees_up_dev.pid"

# Function to start the app
start_app() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Fees-Up Flutter app on Linux..." >> "$LOG_FILE"
    
    cd "$PROJECT_DIR"
    
    # Load environment variables
    if [ -f "assets/keys.env" ]; then
        export $(cat assets/keys.env | grep -v '^#' | xargs)
    fi
    
    # Run Flutter
    flutter run \
        -d linux \
        --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
        --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
        --dart-define=ENVIRONMENT=development \
        >> "$LOG_FILE" 2>&1 &
    
    APP_PID=$!
    echo $APP_PID > "$PID_FILE"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - App started with PID: $APP_PID" >> "$LOG_FILE"
    
    # Wait for the app process
    wait $APP_PID
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - App exited" >> "$LOG_FILE"
}

# Function to stop the app
stop_app() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Stopping app (PID: $PID)" >> "$LOG_FILE"
            kill $PID
            rm "$PID_FILE"
        fi
    fi
}

# Handle signals
trap stop_app SIGTERM SIGINT

# Main loop - keeps the app running, restarts if it crashes
while true; do
    start_app
    
    # If app exited unexpectedly, wait before restarting
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - App crashed, restarting in 5 seconds..." >> "$LOG_FILE"
        sleep 5
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - App stopped normally" >> "$LOG_FILE"
        break
    fi
done
