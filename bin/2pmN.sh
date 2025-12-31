#!/bin/bash
# Fees-Up Linux Development - Direct Run Script
# Simple, debuggable launcher with full console output

set -e

echo "📁 Changing to project directory..."
cd "$(dirname "$0")"

echo "📋 Loading environment variables..."
if [ -f "assets/keys.env" ]; then
    export $(cat assets/keys.env | grep -v '^#' | xargs)
    echo "✅ Environment loaded"
else
    echo "⚠️  No assets/keys.env found"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           FEES-UP FLUTTER - LINUX DEVELOPMENT                 ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Platform: Linux"
echo "Mode: Debug (with hot reload)"
echo ""
echo "Controls:"
echo "  r  - Hot reload"
echo "  R  - Hot restart  "
echo "  q  - Quit"
echo "  h  - Help"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run Flutter with hot reload enabled
flutter run \
  -d linux \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  --dart-define=POWERSYNC_ENDPOINT_URL="${POWERSYNC_ENDPOINT_URL}" \
  --dart-define=ENVIRONMENT=development
