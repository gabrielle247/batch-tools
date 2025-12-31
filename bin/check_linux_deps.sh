#!/bin/bash
# Check and install Linux dependencies for Flutter + SQLite

echo "🔍 Checking Linux dependencies for Fees Up..."

# Check for SQLite development libraries
if ! dpkg -l | grep -q libsqlite3-dev; then
    echo "❌ libsqlite3-dev is not installed"
    echo "📦 Installing libsqlite3-dev..."
    sudo apt-get update
    sudo apt-get install -y libsqlite3-dev
else
    echo "✅ libsqlite3-dev is installed"
fi

# Check for other required libraries
REQUIRED_LIBS=(
    "libgtk-3-dev"
    "libblkid-dev"
    "liblzma-dev"
)

for lib in "${REQUIRED_LIBS[@]}"; do
    if ! dpkg -l | grep -q "$lib"; then
        echo "⚠️  $lib is not installed (may be needed for Flutter Linux)"
    else
        echo "✅ $lib is installed"
    fi
done

echo ""
echo "🚀 Dependencies check complete!"
echo "💡 To install all Flutter Linux dependencies, run:"
echo "   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libblkid-dev libsqlite3-dev"
