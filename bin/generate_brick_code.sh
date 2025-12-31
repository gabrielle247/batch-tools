#!/bin/bash
# Brick Code Generation Script
# Run this after fixing Brick setup to generate adapters and migrations

echo "🧱 Starting Brick code generation..."
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
dart run build_runner clean

# Run build_runner
echo "🔨 Generating Brick adapters and migrations..."
dart run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ Code generation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Check generated files in lib/brick/adapters/"
echo "2. Update lib/brick/brick.g.dart to use generated dictionaries"
echo "3. Run tests: dart test"
echo "4. Initialize Brick in main.dart: await BrickRepository.instance.initialize()"
echo ""
