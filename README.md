# MySimpleNotes App

A Simple Notes Application developed for the KU BSc Program - Mobile Application Development Module Coursework 01 - A

- KU ID: K2430660
- Name: U. D. Chamika Srimantha
- Module Code: C16330
- Module Name: Mobile Application Development

## Getting Started

1. Install Flutter SDK. (Flutter Version: 3.24.3)
2. Install Android Studio.
3. Add sqflite and path dependencies. (sqflite: ^2.4.0, path: ^2.0.11)
4. Install JDK. (JDK: 17)
5. Run the project.

### If you are getting any error, make sure to double check these files:

- under android folder settings.gradle
  `plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.3.2" apply false
    id "org.jetbrains.kotlin.android" version "1.8.22" apply false
  }`
- under android/gradle folder gradle-wrapper.properties
  `distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip`
- under android/app folder build.gradle
  `ndkVersion = "25.1.8937393"`