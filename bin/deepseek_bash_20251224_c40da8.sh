# Create a single comprehensive file with everything
{
  echo "=== DIRECTORY STRUCTURE ==="
  ls -la
  echo ""
  
  echo "=== PUBSPEC.YAML ==="
  cat pubspec.yaml 2>/dev/null || echo "Not found"
  echo ""
  
  echo "=== ALL DART FILES ==="
  find lib -name "*.dart" -exec sh -c 'echo "=== FILE: {} ===" && cat {} && echo ""' \;
  
  echo "=== ANDROID CONFIG ==="
  find android/app -name "*.gradle" -o -name "AndroidManifest.xml" -o -name "build.gradle" 2>/dev/null | while read file; do echo "=== FILE: $file ==="; cat "$file"; echo ""; done
  
  echo "=== IOS CONFIG (if exists) ==="
  find ios -name "Info.plist" -o -name "*.xcconfig" 2>/dev/null | head -5 | while read file; do echo "=== FILE: $file ==="; cat "$file"; echo ""; done
  
  echo "=== ENVIRONMENT FILES ==="
  find . -name ".env*" -o -name "*.env" 2>/dev/null | while read file; do echo "=== FILE: $file ==="; cat "$file"; echo ""; done
} > complete_project_context.txt

echo "✅ Created complete_project_context.txt"