---
description: Repository Information Overview
alwaysApply: true
---

# The Prisoner's Dilemma Information

## Summary
A comprehensive Flutter application implementing the classic Prisoner's Dilemma game theory concept. The game features multiple AI strategies, local multiplayer, animated visuals, and educational content about game theory. It provides both entertainment and educational value by demonstrating various strategies in the iterated Prisoner's Dilemma.

## Structure
- **lib/**: Core application code organized in MVC-like pattern
  - **common/**: Shared utilities, enums, and constants
  - **models/**: Data models and strategy implementations
  - **repository/**: State management with Riverpod
  - **view/**: Screen implementations
  - **widgets/**: Reusable UI components
- **assets/**: Application assets including images
- **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific code
- **test/**: Test files (currently commented out)

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.8.1
**Framework**: Flutter
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter: SDK
- cupertino_icons: ^1.0.8
- flutter_riverpod: ^2.6.1
- pwa_install: ^0.0.6

**Development Dependencies**:
- flutter_test: SDK
- flutter_lints: ^5.0.0
- flutter_launcher_icons: ^0.14.4

## Build & Installation
```bash
# Get dependencies
flutter pub get

# Run in development mode
flutter run

# Build for web
flutter build web

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

## Testing
**Framework**: flutter_test
**Test Location**: test/
**Naming Convention**: *_test.dart
**Run Command**:
```bash
flutter test
```

## Features
- **Game Modes**: User vs Computer (10 AI strategies), User vs User
- **Visual Elements**: Animated stick figures with reactions
- **Game Logic**: Complete payoff matrix implementation
- **Strategy Encyclopedia**: Comprehensive guide with strategy details
- **State Management**: Riverpod for reactive UI updates
- **Responsive Design**: Works on mobile and web platforms