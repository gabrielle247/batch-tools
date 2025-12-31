#!/bin/bash

# 1. CLEANUP
# Remove potential conflicts and old lock files to ensure a fresh start
echo "Cleaning project..."
flutter clean
rm pubspec.lock

# 2. REMOVE CONFLICTING PACKAGES
# We remove 'sqflite' to avoid conflict with 'sqflite_sqlcipher'
# We remove 'provider' and 'flutter_bloc' to strictly use 'riverpod'
echo "Removing conflicting packages..."
flutter pub remove sqflite provider flutter_bloc lint

# 3. INSTALL "STRICT" PACKAGES FIRST
# These packages have strict dependencies. Installing them first allows 
# Flutter to calculate the ceiling for other packages (like connectivity_plus)
echo "Installing strict dependency packages..."
flutter pub add velocity_x                  # Often dictates the 'intl' version
flutter pub add internet_connection_checker # Dictates 'connectivity_plus' version
flutter pub add sqflite_sqlcipher           # Replaces standard sqflite

# 4. INSTALL REMAINING DEPENDENCIES
# Now we add the rest, letting Pub calculate the latest compatible versions
echo "Installing core dependencies..."
flutter pub add cupertino_icons
flutter pub add flutter_svg
flutter pub add fl_chart
flutter pub add gap
flutter pub add flutter_animate
flutter pub add responsive_framework
flutter pub add image_picker
flutter pub add go_router
flutter pub add intl
flutter pub add uuid
flutter pub add equatable
flutter pub add path
flutter pub add path_provider
flutter pub add permission_handler
flutter pub add connectivity_plus
flutter pub add supabase_flutter
flutter pub add sqflite_common_ffi
flutter pub add shared_preferences
flutter pub add flutter_secure_storage
flutter pub add flutter_riverpod
flutter pub add local_auth

# 5. INSTALL DEV DEPENDENCIES
# Tools for code generation and testing
echo "Installing dev dependencies..."
flutter pub add --dev flutter_lints
flutter pub add --dev build_runner
flutter pub add --dev json_serializable
flutter pub add --dev go_router_builder

echo "✅ All packages installed successfully with best compatible versions!"



