#!/bin/bash

echo "🚀 Initiating Repo Hijack..."

# 1. Stage ALL local changes (new files, modifications, deletions)
# This captures everything currently on your disk.
git add .

# 2. Commit everything
# We use a timestamp to distinguish this "reset" point.
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Hijack: Enforcing local state as master truth [$timestamp]"

# 3. The Nuclear Option: Force push
# This overwrites the remote 'main' branch with your local version.
# It ignores any history on GitHub that doesn't exist locally.
# If your branch is named 'master', change 'main' to 'master' below.
git branch -M main
git push origin main --force

echo "✅ Github Repo hijacked. Your local code is now the absolute truth on the remote."