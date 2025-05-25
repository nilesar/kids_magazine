
# 📚 Android Kid Magazine App (V5 - 2025)

In this age of mobility, many families migrate across regions or countries for work. Children of such immigrant parents are often raised away from their native regions. While many of these children understand and speak their mother tongue fluently, most cannot read or write it. This is largely due to the lack of proper educational infrastructure in schools outside their home states.

Our app solves this problem by offering a fun and educational platform. It transliterates literary content from Indian languages into Roman script (used in English, which is widely taught across India), helping children learn to read their native language. The app also features **audio narration**, enabling users to **listen, read, and learn** in both native and Roman scripts.
## 🔁 [View the App's Workflow](https://drive.google.com/file/d/1hWtNysAHUUUAa2F8NdbCFs9Na2OfDRQh/view?usp=drive_link)

---

## ✨ Features

- 📖 Read stories in **Bengali, Gujarati, Telugu, Marathi and Hindi**
- 🔤 Romanized (transliterated) script for easy learning
- 🔊 Built-in audio narration
- 📂 Anyone can upload `.txt` files with new stories
- 🧑‍🏫 Story content is reviewed before public release
- ✅ No login needed for story access
- 🧑‍💻 Adults (parents or contributors) can register and upload stories

We welcome your contribution! Help us enrich the story collection by submitting age-appropriate, value-based literature in any supported language.

---

## 🧩 Developer Notes (General Guidelines)

- Migrated from Flutter **Android Embedding v1 → v2**  
  👉 [Upgrade Guide](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

- Ensure compatibility between:
  - Flutter SDK
  - Android SDK version
  - Gradle version
  - Kotlin version  
  📍 Edit these in `android/build.gradle` and `android/app/build.gradle`.

- **Use Android Studio** for emulator setup and Gradle handling.
- **VS Code** is recommended for coding.

---

## ⚠️ Developer Reminders (For Version 2025)

> **🚨 Don't mess with Gradle unless you have a backup!**
- Always run a fresh `flutter create demo_app` if unsure about Java/Gradle issues.
- Fix and lock:
  - `compileSdkVersion`
  - `minSdkVersion`
  - `targetSdkVersion`
- Check compatibility using the official Flutter & Android [version matrix](https://docs.flutter.dev/development/tools/sdk/releases).

---

## 🔧 Common Build & Debug Commands

```bash
flutter doctor           # Fix all environment issues
flutter pub get          # Fetch dependencies
flutter pub upgrade      # Upgrade dependencies
flutter clean            # Clean the build
flutter pub cache repair # Repair the pub cache

# Android-specific build steps:
cd android
./gradlew clean
./gradlew build

## **KEY>PROPERTIES**
storePassword=IrLaBiItBhU2021
keyPassword=IrLaBiItBhU
storeFile=../app/tests.jks
keyAlias=key




# Back to root directory
flutter build apk        # Build the release APK


📎 Troubleshooting Tips
If build issues persist, use:

Stack Overflow

Flutter GitHub Issues






Flutter and Android Discord/Reddit developer communities



📊 Understanding the App Workflow
To fully understand the inner workings and structure of the app, refer to the app's official presentation (ask the team for access).
https://drive.google.com/file/d/177q0IMoogFmPvKLWgsF6Dv5zbtDO6CNu/view?usp=sharing
=======
# Android_Kids_Magazine_V5

