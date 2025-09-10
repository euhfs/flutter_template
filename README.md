# A Flutter Template for easier start of projects (mainly android)

# Instalation

- Download the .zip from the Code button
- or by using the "Use this template" button

# **IMPORTANT**

### **For android you need to get a release key for your app to do that run the following command in a terminal**:

- keytool -genkeypair -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload_key


**Here you need to create a unique and strong password. I recommend to create a 64 length password using ONLY a-z, A-Z, 0-9 so you don't have errors later.**

***
Enter keystore password:

Re-enter new password:
***

**Here you can either complete with the actual requirements or just enter random things.**

- What is your first and last name?
-    []:  name
- What is the name of your organizational unit?
-    []:  name
- What is the name of your organization?
-    []:  name
- What is the name of your City or Locality?
-    []:  name
- What is the name of your State or Province?
-    []:  name
- What is the two-letter country code for this unit?
-    []:  name

***

**And here just type "yes" and that should be it.**

Is CN=name, OU=name, O=name, L=name, ST=name, C=name correct?
-    [no]:  yes

***

After you got the release.jks go to your project and inside android/app/release.jks just replace the release.jks and then go to android/key.properties and replace "PASSWORD" with the keystore password you just entered in that terminal command.

### Also go to android/app/src/main/AndroidManifest.xml and replace the app label to your actual app name

### And change the app package name from all of these:

- android/app/build.gradle.kts
- android/app/src/main/kotlin/com/example/flutter_template/MainActivity.kt

**Inside build.gradle.kts find: namespace = "com.example.flutter_template"\napplicationId = "com.example.flutter_template"\n And change the package name to something like: "com.euhfs.my_flutter_app"**
**And inside MainActivity.kt find package "com.example.flutter_template" and change that too**


# To add other platforms run the command for each platform inside the root folder you want to add for your project:

- flutter create . --platforms=windows
- flutter create . --platforms=linux
- flutter create . --platforms=web
- flutter create . --platforms=macos
- flutter create . --platforms=ios

# Predefinied dark/light theme + custom colors

In the lib folder there is another folder called utils where you can find:

- app_theme.dart
- colors.dart
- custom_colors.dart

app_theme.dart is where the actual dark/light mode themes are.
colors.dart is where the main UI colors are.
custom_colors.dart is where other UI colors are.

