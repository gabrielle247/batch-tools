#!/bin/bash
# Fees-Up Linux Development Launcher
# Automatically runs the Flutter app on Linux desktop

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           FEES-UP FLUTTER APP - LINUX DEVELOPMENT             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📁 Project Directory: $SCRIPT_DIR"
echo ""

# Check if environment file exists
if [ ! -f "assets/keys.env" ]; then
    echo "⚠️  Warning: assets/keys.env not found"
    echo "   The app may not connect to Supabase without environment variables."
    echo ""
fi

# Load environment variables if they exist
if [ -f "assets/keys.env" ]; then
    export $(cat assets/keys.env | grep -v '^#' | xargs)
    echo "✅ Environment variables loaded from assets/keys.env"
else
    echo "⚠️  No environment file found. Using defaults..."
fi

echo ""
echo "🚀 Starting Flutter app on Linux..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run Flutter with proper flags for Linux
flutter run \
  -d linux \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  --dart-define=ENVIRONMENT=development

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛑 App closed"
