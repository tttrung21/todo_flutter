#!/bin/bash
# Stop if meeting error
set -e

# Flutter Build APK Script

# Clean old build
flutter clean

# Installing dependencies
flutter pub get
flutter pub global activate intl_utils

flutter pub global run intl_utils:generate

# Build APK
if flutter build apk --release; then
    echo "Building APK successfully!"
    echo "APK's path: build/app/outputs/flutter-apk/app-release.apk"
else
    echo "Error: Unable to build APK."
    exit 1
fi