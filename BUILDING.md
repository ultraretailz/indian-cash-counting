# Building Indian Cash Counting App

This guide explains how to build and generate the APK for the Indian Cash Counting application.

## Prerequisites

### 1. Install Flutter SDK

**On Windows/Mac/Linux:**
- Download Flutter SDK from: https://flutter.dev/docs/get-started/install
- Extract and add Flutter to your PATH

**Verify Installation:**
```bash
flutter --version
flutter doctor
```

### 2. Install Android SDK

**Option 1: Using Android Studio (Recommended)**
- Download Android Studio: https://developer.android.com/studio
- Install and run Android Studio
- Open SDK Manager and install:
  - Android SDK Platform 33 (or higher)
  - Android SDK Build-Tools 33.0.0
  - Android SDK Platform-Tools
  - Android Emulator

**Option 2: Command Line**
```bash
# Set ANDROID_SDK_ROOT environment variable
export ANDROID_SDK_ROOT=~/Android/Sdk  # On Linux/Mac
set ANDROID_SDK_ROOT=C:\Users\YourName\AppData\Local\Android\sdk  # On Windows

# Install required components
sdkmanager "platforms;android-33"
sdkmanager "build-tools;33.0.0"
sdkmanager "system-images;android-33;google_apis;x86_64"
```

### 3. Configure Flutter

```bash
# Enable Android and Web support
flutter config --enable-android
flutter config --enable-web

# Accept Android licenses
flutter doctor --android-licenses
```

## Building Steps

### 1. Clone the Repository

```bash
git clone https://github.com/ultraretailz/indian-cash-counting.git
cd indian-cash-counting
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download:
- sqflite (SQLite database)
- uuid (ID generation)
- path (file path utilities)

### 3. Run on Emulator (Optional)

**Start Android Emulator:**
```bash
# List available emulators
flutter emulators

# Start an emulator
flutter emulators --launch emulator_name

# Or create a new one via Android Studio
```

**Run on Emulator:**
```bash
flutter run
```

### 4. Build Release APK

#### Method 1: Basic APK

```bash
flutter build apk --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

**Install on Device:**
```bash
# Connect Android device via USB
flutter install build/app/outputs/flutter-apk/app-release.apk
```

#### Method 2: Split APKs (Better for Play Store)

```bash
flutter build apk --release --split-per-abi
```

**Outputs:**
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (32-bit ARM)
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (64-bit ARM)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (x86_64)

#### Method 3: App Bundle for Google Play

```bash
flutter build appbundle --release
```

**Output:** `build/app/outputs/bundle/release/app-release.aab`

## Configuration

### Customize App Name and Icon

#### 1. Change App Name

**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<application
    android:label="Your Custom App Name"
    ...>
</application>
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>CFBundleName</key>
<string>Your Custom App Name</string>
```

#### 2. Change App Icon

Replace icon files at:
- **Android:** `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Or use online icon generator:
- https://icon.kitchen/
- Export and place in directories above

### Customize App Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+buildNumber
```

## Testing Before Release

### 1. Run Unit Tests (if added)
```bash
flutter test
```

### 2. Test on Physical Device

```bash
# Enable USB Debugging on Android phone
# Connect phone via USB
flutter devices
flutter run -d device_id

# Or use:
flutter run -d physical_device
```

### 3. Verify App Functions

- ✓ Add customer
- ✓ Add payment
- ✓ Count cash
- ✓ View transaction history
- ✓ Filter by date
- ✓ View customer summary

## Publishing to Google Play Store

### 1. Create Google Play Developer Account
- Go to: https://play.google.com/console
- Pay one-time $25 registration fee
- Complete profile and payment information

### 2. Sign Release APK

```bash
# Generate keystore (one-time only)
keytool -genkey -v -keystore ~/my-release-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias

# Create signing configuration in Android
# Edit android/app/build.gradle:
```

### 3. Update build.gradle with Signing Config

```gradle
android {
  ...
  signingConfigs {
    release {
      keyAlias 'my-key-alias'
      keyPassword 'password123'
      storeFile file('/path/to/my-release-key.keystore')
      storePassword 'password456'
    }
  }
  
  buildTypes {
    release {
      signingConfig signingConfigs.release
    }
  }
}
```

### 4. Build Signed App Bundle

```bash
flutter build appbundle --release
```

### 5. Upload to Play Store

- Open Google Play Console
- Create new app
- Fill in app details
- Upload app-release.aab
- Fill store listing and content rating
- Submit for review

## Troubleshooting

### Issue: "Flutter SDK not found"
```bash
# Set Flutter path
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: "Android SDK not found"
```bash
# Set Android SDK path
export ANDROID_SDK_ROOT=/path/to/android/sdk
flutter config --android-sdk-path /path/to/android/sdk
```

### Issue: Gradle build fails
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release
```

### Issue: Plugin not found errors
```bash
# Regenerate plugin bindings
flutter pub get
flutter pub run build_runner build
```

### Issue: APK size too large
```bash
# Build with shrinkResources and minifyEnabled
# Edit android/app/build.gradle

# Or use app bundle (smaller)
flutter build appbundle --release
```

## File Locations

```
Output Files:
├── build/app/outputs/flutter-apk/
│   ├── app-release.apk              # Single APK
│   ├── app-armeabi-v7a-release.apk # ARM 32-bit
│   ├── app-arm64-v8a-release.apk   # ARM 64-bit
│   └── app-x86_64-release.apk      # x86 64-bit
└── build/app/outputs/bundle/
    └── release/
        └── app-release.aab          # App Bundle

Database:
└── /data/data/com.example.indian_cash_counting/
    └── databases/
        └── cash_counting.db         # SQLite database (device)
```

## Release Checklist

- [ ] Update version in pubspec.yaml
- [ ] Update CHANGELOG.md
- [ ] Test on physical device
- [ ] Test all features:
  - [ ] Customer management
  - [ ] Payment entry
  - [ ] Cash counting
  - [ ] Transaction history
  - [ ] Date filtering
- [ ] Check APK size
- [ ] Build release APK
- [ ] Sign APK (for Play Store)
- [ ] Upload to Play Store or distribute APK

## Additional Resources

- Flutter Documentation: https://flutter.dev/docs
- Android Build Guide: https://developer.android.com/build
- Google Play Console: https://play.google.com/console
- Firebase Hosting: https://firebase.google.com/products/hosting

## Support

For issues or questions:
- GitHub Issues: https://github.com/ultraretailz/indian-cash-counting/issues
- Flutter Docs: https://flutter.dev/docs
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
