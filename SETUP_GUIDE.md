# SummerSplash Field App - Complete Setup Guide

This guide will help you get the SummerSplash Field App running on your development machine.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Project Setup](#project-setup)
4. [Firebase Configuration](#firebase-configuration)
5. [Running the App](#running-the-app)
6. [Completing the Implementation](#completing-the-implementation)

## Prerequisites

### Required Software
- **Flutter SDK** (version 3.9.2 or higher)
  - Download: https://docs.flutter.dev/get-started/install
- **Android Studio** (for Android development)
  - Download: https://developer.android.com/studio
- **Xcode** (for iOS development, macOS only)
  - Download from Mac App Store
- **VS Code** or **Android Studio** with Flutter extensions
- **Git** (for version control)

### Accounts Needed
- Firebase account (free): https://console.firebase.google.com
- Google Cloud account (for Google Maps, optional)

## Environment Setup

### 1. Install Flutter

**Windows:**
\`\`\`bash
# Download Flutter SDK and extract to C:\\src\\flutter
# Add to PATH: C:\\src\\flutter\\bin

flutter doctor
\`\`\`

**macOS/Linux:**
\`\`\`bash
# Download and extract Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Add to ~/.bashrc or ~/.zshrc
echo 'export PATH="$PATH:~/development/flutter/bin"' >> ~/.bashrc

flutter doctor
\`\`\`

### 2. Install Android Studio

1. Download from https://developer.android.com/studio
2. Install Android SDK
3. Install Flutter and Dart plugins:
   - Open Android Studio
   - Go to Plugins > Install Flutter plugin
   - This will also install Dart

### 3. Accept Android Licenses

\`\`\`bash
flutter doctor --android-licenses
\`\`\`

## Project Setup

### 1. Navigate to Project Directory

\`\`\`bash
cd /home/kopi/Desktop/Projects/summersplash_field_app
\`\`\`

### 2. Install Dependencies

\`\`\`bash
flutter pub get
\`\`\`

### 3. Configure API Endpoint

Edit \`lib/config/app_config.dart\` and update the API URL:

\`\`\`dart
static const String apiBaseUrl = 'http://YOUR_API_URL/api';
\`\`\`

Replace \`YOUR_API_URL\` with:
- Local development: \`http://10.0.2.2:5000\` (Android emulator) or \`http://localhost:5000\` (iOS simulator)
- Production: Your deployed API URL

### 4. Configure Android

Edit \`android/app/build.gradle\`:

\`\`\`gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.summersplash.field_app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
\`\`\`

Add location permissions in \`android/app/src/main/AndroidManifest.xml\`:

\`\`\`xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <application>
        <!-- ... -->
    </application>
</manifest>
\`\`\`

### 5. Configure iOS

Edit \`ios/Runner/Info.plist\` and add:

\`\`\`xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to verify clock in/out at job sites</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to track your work location</string>

<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for maintenance records</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select maintenance photos</string>
\`\`\`

## Firebase Configuration

### 1. Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Enter project name: "SummerSplash Field App"
4. Disable Google Analytics (optional)
5. Create project

### 2. Add Android App

1. In Firebase Console, click "Add app" > Android
2. Enter package name: \`com.summersplash.field_app\`
3. Download \`google-services.json\`
4. Place file in: \`android/app/google-services.json\`

Add to \`android/build.gradle\`:

\`\`\`gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
\`\`\`

Add to \`android/app/build.gradle\`:

\`\`\`gradle
apply plugin: 'com.google.gms.google-services'
\`\`\`

### 3. Add iOS App

1. In Firebase Console, click "Add app" > iOS
2. Enter bundle ID: \`com.summersplash.fieldApp\`
3. Download \`GoogleService-Info.plist\`
4. Open Xcode: \`open ios/Runner.xcworkspace\`
5. Drag \`GoogleService-Info.plist\` to Runner folder in Xcode

### 4. Enable Cloud Messaging

1. In Firebase Console, go to "Build" > "Cloud Messaging"
2. Enable Cloud Messaging API

## Running the App

### Check Connected Devices

\`\`\`bash
flutter devices
\`\`\`

### Run on Android Emulator

\`\`\`bash
# Start emulator
emulator -avd Pixel_7_Pro_API_34

# Run app
flutter run
\`\`\`

### Run on iOS Simulator

\`\`\`bash
# Open simulator
open -a Simulator

# Run app
flutter run -d ios
\`\`\`

### Run on Physical Device

**Android:**
1. Enable Developer Options on device
2. Enable USB Debugging
3. Connect via USB
4. Run \`flutter run\`

**iOS:**
1. Connect device
2. Open Xcode
3. Sign app with your Apple Developer account
4. Run \`flutter run -d ios\`

## Completing the Implementation

The foundation is in place. Here's what you need to implement:

### 1. Authentication Screens (Priority: HIGH)

Create in \`lib/screens/auth/\`:
- \`login_screen.dart\` - Full login form
- \`register_screen.dart\` - Registration with role selection
- \`forgot_password_screen.dart\` - Password reset

### 2. Role-Based Dashboards (Priority: HIGH)

Create in \`lib/screens/dashboard/\`:
- \`lifeguard_dashboard.dart\` - Clock in/out, view schedule
- \`service_tech_dashboard.dart\` - Checklist access, clock in/out
- \`manager_dashboard.dart\` - Staff overview, safety audits

### 3. Service Technician Module (Priority: HIGH)

Create in \`lib/screens/checklist/\`:
- \`service_checklist_screen.dart\` - Main checklist view
- \`chemical_readings_screen.dart\` - Chemical input form
- \`photo_capture_screen.dart\` - Photo requirements

### 4. Time Entry Management (Priority: MEDIUM)

Create in \`lib/screens/time_entry/\`:
- \`clock_in_screen.dart\` - GPS verification and clock in
- \`clock_out_screen.dart\` - Clock out confirmation
- \`time_history_screen.dart\` - View past entries

### 5. Offline Sync Service (Priority: MEDIUM)

Create in \`lib/services/local_storage/\`:
- \`hive_service.dart\` - Hive box management
- \`sync_service.dart\` - Background sync logic

### 6. Shared Widgets (Priority: LOW)

Create in \`lib/widgets/\`:
- \`custom_text_field.dart\` - Styled input fields
- \`loading_button.dart\` - Button with loading state
- \`location_card.dart\` - Display location info
- \`checklist_item.dart\` - Reusable checklist item

## Testing

### Run Tests

\`\`\`bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
\`\`\`

### Generate Test Coverage

\`\`\`bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
\`\`\`

## Building for Production

### Android APK

\`\`\`bash
flutter build apk --release
\`\`\`

Output: \`build/app/outputs/flutter-apk/app-release.apk\`

### Android App Bundle (for Play Store)

\`\`\`bash
flutter build appbundle --release
\`\`\`

Output: \`build/app/outputs/bundle/release/app-release.aab\`

### iOS (requires Mac)

\`\`\`bash
flutter build ios --release
\`\`\`

Then archive in Xcode for App Store submission.

## Troubleshooting

### Common Issues

**1. "Waiting for another flutter command to release the startup lock"**
\`\`\`bash
rm -rf ~/.flutter/bin/cache/lockfile
\`\`\`

**2. "Unable to locate Android SDK"**
\`\`\`bash
flutter config --android-sdk /path/to/android/sdk
\`\`\`

**3. "Pod install failed" (iOS)**
\`\`\`bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
\`\`\`

**4. "Firebase not initialized"**
- Verify \`google-services.json\` and \`GoogleService-Info.plist\` are in correct locations
- Check Firebase configuration code in \`main.dart\`

**5. "Location permission denied"**
- Verify permissions in AndroidManifest.xml (Android) and Info.plist (iOS)
- Request permissions at runtime in code

## Next Steps

1. Start with authentication screens
2. Implement service tech dashboard and checklist
3. Add GPS-based clock in/out
4. Implement offline storage
5. Add photo capture
6. Test thoroughly with real devices
7. Deploy to Test Track on Play Store / TestFlight

## Resources

- Flutter Documentation: https://docs.flutter.dev
- Bloc Library: https://bloclibrary.dev
- Hive Database: https://docs.hivedb.dev
- Firebase for Flutter: https://firebase.flutter.dev
- Geolocator Plugin: https://pub.dev/packages/geolocator

## Support

For questions or issues:
- Check existing issues on GitHub
- Read Flutter documentation
- Contact development team

---

Generated with Claude Code - https://claude.com/claude-code
