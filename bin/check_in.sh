#!/bin/bash

echo "Checking for missing packages in offline mode..."
flutter pub get --offline > pub_log.txt 2>&1

if grep -q "No cached version" pub_log.txt; then
  echo "❌ Missing cached dependencies. Terminating."
  exit 1
else
  echo "✅ All packages found in cache."
fi
