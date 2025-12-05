#!/bin/bash

# Development Helper Script for Front Office 2
# This script provides shortcuts for common development tasks

case "$1" in
  "clean")
    echo "🧹 Cleaning build cache..."
    flutter clean
    cd android && ./gradlew clean && cd ..
    echo "✅ Clean completed!"
    ;;

  "rebuild")
    echo "🔨 Full rebuild..."
    flutter clean
    flutter pub get
    cd android && ./gradlew clean && cd ..
    echo "✅ Ready to run!"
    ;;

  "run")
    echo "🚀 Running app..."
    flutter run
    ;;

  "run-release")
    echo "🚀 Running in release mode..."
    flutter run --release
    ;;

  "hot-restart")
    echo "🔥 Performing hot restart..."
    echo "Press 'R' in the Flutter console or use: flutter run and press 'R'"
    ;;

  "cache-repair")
    echo "🔧 Repairing Flutter cache..."
    flutter pub cache repair
    flutter clean
    flutter pub get
    echo "✅ Cache repaired!"
    ;;

  "gradle-clean")
    echo "🧹 Cleaning Gradle cache..."
    cd android
    ./gradlew clean
    ./gradlew --stop
    cd ..
    echo "✅ Gradle cleaned!"
    ;;

  "full-reset")
    echo "💥 Full reset (use with caution)..."
    flutter clean
    cd android
    ./gradlew clean
    ./gradlew --stop
    rm -rf ~/.gradle/caches/
    cd ..
    flutter pub cache repair
    flutter pub get
    echo "✅ Full reset completed!"
    ;;

  *)
    echo "📱 Front Office 2 - Development Helper"
    echo ""
    echo "Usage: ./dev_helper.sh [command]"
    echo ""
    echo "Available commands:"
    echo "  clean          - Clean Flutter build cache"
    echo "  rebuild        - Full rebuild (clean + pub get)"
    echo "  run            - Run app in debug mode"
    echo "  run-release    - Run app in release mode"
    echo "  hot-restart    - Info about hot restart"
    echo "  cache-repair   - Repair Flutter cache"
    echo "  gradle-clean   - Clean Gradle cache"
    echo "  full-reset     - Nuclear option: reset everything"
    echo ""
    echo "💡 Tips for hot reload issues:"
    echo "  1. Use 'r' for hot reload, 'R' for hot restart"
    echo "  2. If hot reload doesn't work, try hot restart (R)"
    echo "  3. For major changes, use: ./dev_helper.sh rebuild"
    echo "  4. For persistent issues, use: ./dev_helper.sh full-reset"
    ;;
esac
