# Create a comprehensive backup of your entire project
# This captures everything in a readable format:

# 1. First, create a directory for the output
mkdir -p project_backup

# 2. Capture all Dart files (you already have this, but here's the complete version)
find . -name "*.dart" -type f ! -path "./build/*" ! -path "./.dart_tool/*" ! -path "./.git/*" -exec cat {} \; > project_backup/all_dart_files.txt

# 3. Capture ALL configuration files
find . -type f \( -name "pubspec.yaml" -o -name "pubspec.lock" -o -name "*.json" -o -name "*.xml" -o -name "*.gradle" -o -name "*.properties" -o -name "*.plist" -o -name "*.md" -o -name "*.txt" -o -name "*.env*" -o -name ".gitignore" -o -name "Makefile" \) ! -path "./build/*" ! -path "./.dart_tool/*" ! -path "./.git/*" ! -path "./node_modules/*" -exec sh -c 'echo "=== FILE: {} ===" && cat {} && echo ""' \; > project_backup/config_files.txt

# 4. Capture Android-specific files
find android -type f \( -name "*.gradle" -o -name "*.xml" -o -name "*.properties" -o -name "*.kt" -o -name "*.java" \) ! -path "*/build/*" 2>/dev/null | while read file; do echo "=== ANDROID FILE: $file ==="; cat "$file"; echo ""; done > project_backup/android_files.txt 2>/dev/null

# 5. Capture iOS-specific files (if you have iOS)
find ios -type f \( -name "*.plist" -o -name "*.pbxproj" -o -name "*.xcconfig" -o -name "*.swift" \) ! -path "*/build/*" 2>/dev/null | while read file; do echo "=== IOS FILE: $file ==="; cat "$file"; echo ""; done > project_backup/ios_files.txt 2>/dev/null 2>/dev/null

# 6. Capture root directory structure
ls -la > project_backup/directory_structure.txt
find . -maxdepth 3 -type d | sort > project_backup/directory_tree.txt

# 7. Create a combined file for easy sharing
cat project_backup/all_dart_files.txt project_backup/config_files.txt project_backup/android_files.txt > project_backup/complete_context.txt

echo "✅ Project backup created in project_backup/ folder"
echo "📁 Main combined file: project_backup/complete_context.txt"