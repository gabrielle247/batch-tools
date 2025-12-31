# Just the absolute essentials
{
  cat pubspec.yaml
  echo "=== ALL DART FILES ==="
  find lib -name "*.dart" -exec cat {} \;
  echo "=== ANDROID MAIN FILES ==="
  cat android/app/build.gradle 2>/dev/null || echo "No Android build.gradle"
  cat android/app/src/main/AndroidManifest.xml 2>/dev/null || echo "No AndroidManifest"
} > project_context.txt