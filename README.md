# Flutter Project Template

A simple and opinionated Flutter project template to help you quickly get started, especially for Android development.  
Includes pre-configured themes, color management, and release key instructions.

---

## 📑 Table of Contents

**Use the links below to navigate quickly through the README.**

- [Installation](#installation)
- [⚠️IMPORTANT: Android Release Key Setup](#-important-android-release-key-setup)
- [Adding the Key to Your Project](#adding-the-key-to-your-project)
- [Update the App Name](#update-the-app-name)
- [Change the App Package Name](#change-the-app-package-name)
- [Adding Other Platforms](#adding-other-platforms)
- [Predefined Dark/Light Themes & Custom Colors](#predefined-darklight-themes--custom-colors)
- [Folder Structure](#folder-structure)
- [App Name, Version, Icon & Splash Screen Setup](#app-name-version-icon--splash-screen-setup)

---

## 📦 Installation

1. **Download the template**  
   - Either download the `.zip` from the **Code** button,  
   - Or click the **"Use this template"** button.

---

## ⚠️ IMPORTANT: Android Release Key Setup

To release an Android app, you need a **release key**.

Run the following command in a terminal:

```bash
keytool -genkeypair -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload_key
```

### Password Recommendation
- Create a **unique and strong password**.  
- Recommended: a **64-character password** using only `a-z`, `A-Z`, and `0-9`.  
- This helps avoid errors later.

---

### Terminal Prompts

```text
Enter keystore password: <your-password>
Re-enter new password: <your-password>
```

Then fill in the following (you can use random placeholder values if you prefer):

| Question                                             | Example   |
|-----------------------------------------------------|-----------|
| What is your first and last name?                   | name      |
| What is the name of your organizational unit?       | name      |
| What is the name of your organization?              | name      |
| What is the name of your City or Locality?          | name      |
| What is the name of your State or Province?         | name      |
| What is the two-letter country code for this unit?  | name      |

Finally:

```text
Is CN=name, OU=name, O=name, L=name, ST=name, C=name correct?
[no]: yes
```

---

### Adding the Key to Your Project

1. Place your `release.jks` file in:  
   ```
   android/app/release.jks
   ```

2. Create a file `key.properties` in `android/key.properties`  
   Replace `"PASSWORD"` with the **keystore password** you created above.

   ```
   storeFile=release.jks
   storePassword=PASSWORD
   keyAlias=upload_key
   keyPassword=PASSWORD
   ```

**Skip this step if it's already done for you**
3. Set release key in `android/app/build.gradle.kts`

   * Add at the top of the file:
     ```kotlin
     import java.util.Properties
     import java.io.FileInputStream
     ```

   * Add after `plugins`:
     ```kotlin
     // Load keystore properties
     val keystoreProperties = Properties()
     val keystorePropertiesFile = rootProject.file("key.properties")
     if (keystorePropertiesFile.exists()) {
     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
     }
     ```
   * And finally replace `buildTypes` with:
     ```kotlin
     signingConfigs {
        create("release") {
           keyAlias = keystoreProperties["keyAlias"] as String
           keyPassword = keystoreProperties["keyPassword"] as String
           storeFile = keystoreProperties["storeFile"]?.let { file(it.toString()) }
           storePassword = keystoreProperties["storePassword"] as String
        }
     }


     buildTypes {
        getByName("release") {
           signingConfig = signingConfigs.getByName("release")
           isMinifyEnabled = true
           isShrinkResources = true
        }
     }
     ```
     # Important:
     The keystore password and other sensitive data won't be committed to GitHub since they are in .gitignore, but I still recommend checking .gitignore to make sure everything is correct.

     # Proguard-rules
     Make sure to go to `android/app/proguard-rules.pro` and change this line: 

     ```proguard
     # Keep your own app code
     -keep class com.example.flutter_template.** { *; }
     ```

     To your package name.

 ---

### Update the App Name

In `android/app/src/main/AndroidManifest.xml`, replace the **app label** with your actual app name.

---

### Change the App Package Name

You must change the package name in:

1. `android/app/build.gradle.kts`
2. `android/app/src/main/kotlin/com/example/flutter_template/MainActivity.kt`

In **build.gradle.kts**:

```kotlin
namespace = "com.example.flutter_template"
applicationId = "com.example.flutter_template"
```

Change both to your new package name, e.g.:

```kotlin
namespace = "com.euhfs.my_flutter_app"
applicationId = "com.euhfs.my_flutter_app"
```

In **MainActivity.kt**, change:

```kotlin
package com.example.flutter_template
```

to your new package name.

---

## ➕ Adding Other Platforms

Run the following commands from the **root folder** of your project to add platforms:

```bash
flutter create . --platforms=windows
flutter create . --platforms=linux
flutter create . --platforms=web
flutter create . --platforms=macos
flutter create . --platforms=ios
```

---

## 🎨 Predefined Dark/Light Themes & Custom Colors

Inside the `lib/utils` folder, you’ll find:

- `app_theme.dart` — contains the actual dark/light mode themes.
- `colors.dart` — defines the main UI colors.
- `custom_colors.dart` — defines additional/custom UI colors.

---

## Folder Structure

The folder structure is located in `/lib` by default, supporting both desktop and mobile. Delete the desktop or mobile folders if you do not need them.

* First in the main function in `main.dart` it loads: `AppLayout()` which decides based on the width of the screen if it should build the *Mobile* or *Desktop* UI. If it's desktop it builds: `MainScreenDesktop()` and if it's mobile it builds: `MainScreenMobile()`.

* Then `MainScreenDesktop()` and `MainScreenMobile()` can be your entry for your app. For example `MainScreenMobile()` can be where you can have your pages and have the app bar and bottom navigation bar for your app as it is already done for you.

---

## App Name, Version, Icon & Splash Screen Setup

### Update app name and version in `pubspec.yaml`:

```yaml
name: your_app_name        # Change to your app’s name (use lowercase_with_underscores)
version: 1.0.0+1           # Update version and build number as needed
```

---

### App Icon

Configure flutter_icons in pubspec.yaml:

```yaml
# Make sure to edit as needed (for app icon)
# I recommend https://icon.kitchen/ to generate an 512x512 PNG icon
flutter_icons:
  android: true
  ios: true
  windows:
    generate: true
    icon_size: 128
  linux:
    generate: true
    icon_size: 128
  macos:
    generate: true
  web:
    generate: true
  adaptive_icon_background: "#FFFFFF"   # Background color for adaptive icons on Android
  image_path: "assets/app-icon/app_icon.png"     # Path to your app icon PNG file
```

after editing the above sections, run the following commands to apply changes run:

```bash
flutter pub get
dart run flutter_launcher_icons
```

---

### Splash Screen

Configure flutter_native_splash in pubspec.yaml:

```yaml
# Make sure to edit as needed (for splash screen)
flutter_native_splash:
  color: "#FFFFFF"                     # Splash screen background color
  icon_background_color: "#FFFFFF"    # Background color behind the splash icon
  android_12:
    color: "#FFFFFF"                   # Splash color for Android 12+
    icon_background_color: "#FFFFFF"
  ios: true                           # Enable splash screen on iOS
  web: true                           # Enable splash screen on web
```

after editing the above sections, run the following commands to apply changes:

```bash
flutter pub get
dart run flutter_native_splash:create
```

---
