#!/bin/bash
# Fees-Up Quick Development Script
# Easy to use, easy to restart, full console output, debuggable

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

load_env() {
    if [ -f "$PROJECT_DIR/assets/keys.env" ]; then
        export $(cat "$PROJECT_DIR/assets/keys.env" | grep -v '^#' | xargs 2>/dev/null)
    fi
}

show_menu() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║            FEES-UP DEVELOPMENT MENU                           ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "  1) Run on Linux (hot reload enabled)"
    echo "  2) Run on Linux (verbose output)"
    echo "  3) Clean rebuild + Run"
    echo "  4) Kill all Flutter processes"
    echo "  5) Show logs"
    echo "  6) Exit"
    echo ""
}

run_linux() {
    load_env
    cd "$PROJECT_DIR"
    echo "🚀 Running on Linux..."
    flutter run -d linux \
        --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
        --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
        --dart-define=POWERSYNC_ENDPOINT_URL="${POWERSYNC_ENDPOINT_URL}" \
        --dart-define=ENVIRONMENT=development
}

run_linux_verbose() {
    load_env
    cd "$PROJECT_DIR"
    echo "🚀 Running on Linux (verbose)..."
    flutter run -d linux \
        --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
        --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
        --dart-define=POWERSYNC_ENDPOINT_URL="${POWERSYNC_ENDPOINT_URL}" \
        --dart-define=ENVIRONMENT=development \
        --verbose
}

clean_run() {
    load_env
    cd "$PROJECT_DIR"
    echo "🧹 Cleaning build..."
    flutter clean
    echo "🔨 Building and running..."
    flutter run -d linux \
        --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
        --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
        --dart-define=POWERSYNC_ENDPOINT_URL="${POWERSYNC_ENDPOINT_URL}" \
        --dart-define=ENVIRONMENT=development
}

kill_flutter() {
    echo "🛑 Killing all Flutter processes..."
    pkill -f "flutter run" || true
    pkill -f "flutter.*linux" || true
    sleep 1
    if pgrep -f "flutter run" > /dev/null; then
        echo "⚠️  Some processes still running, force killing..."
        pkill -9 -f "flutter" || true
    fi
    echo "✅ Done"
}

show_logs() {
    if [ -f "/tmp/fees_up_dev.log" ]; then
        tail -f /tmp/fees_up_dev.log
    else
        echo "No log file found"
    fi
}

# Main loop
while true; do
    show_menu
    read -p "Select option: " choice
    
    case $choice in
        1) run_linux ;;
        2) run_linux_verbose ;;
        3) clean_run ;;
        4) kill_flutter ;;
        5) show_logs ;;
        6) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
