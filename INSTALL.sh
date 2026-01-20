#!/bin/bash

echo "🚀 Installing Aman Booking App..."
echo ""

# Check if we're in aman_booking directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Run this script from inside aman_booking directory"
    echo "   cd aman_booking"
    echo "   ./INSTALL.sh"
    exit 1
fi

# Step 1: Clean
echo "🧹 Cleaning project..."
flutter clean

# Step 2: Enable web
echo "🌐 Enabling web..."
flutter config --enable-web

# Step 3: Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Step 4: Build web
echo "🏗️  Building for web..."
flutter build web --release

# Step 5: Run
echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 Starting app in Chrome..."
flutter run -d chrome

