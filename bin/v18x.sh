#!/bin/bash
# Development run script with environment variables
# Make executable with: chmod +x run_dev.sh

# Load variables from keys.env if it exists
if [ -f "assets/keys.env" ]; then
    export $(cat assets/keys.env | grep -v '^#' | xargs)
fi

# Run Flutter with dart-define flags
flutter run \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  --dart-define=ENVIRONMENT=development \
  "$@"
