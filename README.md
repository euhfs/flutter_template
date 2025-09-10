# Flutter Project Template

A simple Flutter template for quickly starting new projects (mainly for Android).

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

2. Update your `android/key.properties` file:  
   Replace `"PASSWORD"` with the **keystore password** you created above.

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
