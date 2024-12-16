#!/bin/bash
# Stop if meeting error
set -e

# Flutter Build APK Script
echo "=== Building Flutter APK ==="
cd "$(dirname "$0")/../../.."

# Clean old build
sh "flutter clean"

# Installing dependencies
sh flutter pub get

# Generate localization
sh flutter pub global run intl_utils:generate

# Build APK
if flutter build apk --release; then
    echo "Building APK successfully!"
    echo "APK's path: build/app/outputs/flutter-apk/app-release.apk"
else
    echo "Error: Unable to build APK."
    exit 1
fi