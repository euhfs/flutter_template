# A Flutter Template for easier start of projects (mainly android)

# Instalation

- Download the .zip from the Code button

# **IMPORTANT**

**For android you need to get a release key for your app to do that run the following command in a terminal**:

- keytool -genkeypair -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload_key

**It will ask for some stuff for example**:

***
Enter keystore password:

Re-enter new password:
***

To add other platforms run the command for each platform inside the root folder you want to add for your project:

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

