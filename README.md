## Introduction

This Flutter Project Template is a great starting point to build apps fast. It’s made for people who want to spend more time making their app and less time setting it up.

The template works best on Linux, Android, Web, and Windows.

It has easy-to-follow sections that show you how to use scripts to set up and release your project step by step. It also explains how to do everything manually if you want. Using the scripts is the easiest way—they do everything for you and you can have your project ready, with the app icon and all, in less than 30 minutes.

If you get used to the scripts and structure it will take maybe around 10 minutes.

**I recommend to use this for setting up and releasing for iOS/macOS** <br>
https://docs.flutter.dev/deployment/ios <br>
https://docs.flutter.dev/deployment/macos


## Table of contents

- [**Required Tools**](#required-tools)
- [**Build**](#build)
- [**Automated setup**](#automated-setup)
- [**Manual setup**](#manual-setup)
- [**App icon**](#app-icon)
- [**Splash screen**](#splash-screen)
- [**Project structure**](#project-structure)
- [**Adding and removing platforms**](#adding-and-removing-platforms)
- [**Automated release**](#automated-release)
- [**Manual release**](#manual-release)
- [**Publishing**](#publishing)
- [**License**](#license)

## Required tools
**(Based on your operating system)**

1. Windows
    - Install git from: https://git-scm.com/install/windows and follow instructions (I recommend to leave all values to default). (Make sure after installation that you have "Git Bash")
    - Install Inno Setup from: https://jrsoftware.org/isdl.php and follow instructions.

2. Linux
    - Install appimagetool from: https://github.com/AppImage/appimagetool/releases/tag/continuous and get `appimagetool-x86_64.AppImage`

3. macOS
    - Install Xcode from: https://apps.apple.com/us/app/xcode/id497799835?mt=12    

And obviously make sure you have flutter installed. If you want to set up the project for android make sure you have `keytool` installed on your system. All you need to do is install: https://www.oracle.com/java/technologies/downloads/ otherwise android setup won't work.


## Build
**This will guide you step by step on how to download and build this project to modify it into your own template.**

Since the ``setup.sh`` script automatically uses **default** paths for project folders such as Windows and Linux, etc. I generally do **not recommend** manually changing paths, app IDs, or other values. The script will handle all necessary configurations for you **if** you use it.

1. Download
    - Download by clicking the **green code button** and then "Download ZIP" or

    - **Clone** it by using `https://github.com/euhfs/flutter_template.git`

2. Setup
    - **Modify** the template based on your style, I recommend changing **only** the **lib folder**. To learn how the default structure is working check the [project structure](#project-structure)

    - Now you can either **manually** download and change everything each time, or make it work with the `setup.sh` and `build.sh` scripts.

3. Configure scripts
    - First thing **before** you modify the scripts, you have to **publish** your template on **GitHub**. I recommend as **public** because private might have some "permission issues" and only you will be able to access it.

    - In `setup.sh` find the variable **REPO_URL** and change it to your repository with the modified template and it will work perfectly.

    - In `build.sh` modify all the **variables** based on your need and use. For more **details** read the **start** of the script.


## Automated Setup

1. Windows <br>
    **(To paste commands in the terminal use right click)**
    - Open Git Bash and navigate to your preferred directory e.g. `cd ~/Documents` . This navigates to your Documents directory.
    - Now you have to install the setup script and run it. To do that run in the terminal:

        ```bash
        winpty curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && ./setup.sh
        ```
    - Now follow scripts instructions:
        * `Enter the name for the main folder:` <br> The name you would enter when using flutter to generate an project. For example: **password_generator**

        * `Enter the location where it should be installed:` <br> Leave empty to use downloads folder or use your projects folder. For example: **C:\Users\YOURUSER\Documents\MyProjects**

        * `Enter the display name for your app:` <br> The display name is what users will see for your app. For example: **Password Generator**

        * `Enter package name:` <br> A unique identifier for your app, usually in reverse domain format. For example: **com.euhfs.passwordgenerator**

        * `Do you want to set up the keystore for Android? (y/n):` <br> Here you can skip the android keystore setup. It is **very important** if your project is for **android** since it will be used for your release apk and will give errors if you don't have it. (Can still be done **manually** later. Check manual setup on how to set up the keystore)

        * If you chose "y" in the previous step it will ask for **company/dev name** and **password** to be used in the keystore. The company/dev name is not that important and can be anything **BUT** the password is really important, make sure not to lose it.

        * Now you are finished, this template will include folder for every platform available. For example **iOS, Linux** etc. If your project is not for Linux for example, you can just delete the folder. You can still enable a platform in your project, but you will have to **manually** change app names and so on.

2. Linux <br>
    - Open your terminal and navigate to your preferred directory e.g. `cd ~/Documents`.
    - Now you have to install and run the script, to do that run in the terminal:

        ```bash
        curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && chmod +x setup.sh && ./setup.sh
        ```
    - Now follow scripts instructions:
        * `Enter the name for the main folder:` <br> The name you would enter when using flutter to generate an project. For example: **password_generator**

        * `Enter the location where it should be installed:` <br> Leave empty to use downloads folder or use your projects folder. For example: **/home/YOURUSER/Documents/MyProjects**

        * `Enter the display name for your app:` <br> The display name is what users will see for your app. For example: **Password Generator**

        * `Enter package name:` <br> A unique identifier for your app, usually in reverse domain format. For example: **com.euhfs.passwordgenerator**

        * `Do you want to set up the keystore for Android? (y/n):` <br> Here you can skip the android keystore setup. It is **very important** if your project is for **android** since it will be used for your release apk and will give errors if you don't have it. (Can still be done **manually** later. Check manual setup on how to set up the keystore)

        * If you chose "y" in the previous step it will ask for **company/dev name** and **password** to be used in the keystore. The company/dev name is not that important and can be anything **BUT** the password is really important, make sure not to lose it.

        * Now you are finished, this template will include folder for every platform available. For example **iOS, Windows** etc. If your project is not for Windows for example, you can just delete the folder. You can still enable a platform in your project, but you will have to **manually** change app names and so on.

3. macOS <br>
    **For macOS it will most likely be the same as linux**

    * Since I cannot test for macOS myself, the script is not guaranteed to work.

    * My  script tries to at least change the bundle ID and application name for both iOS and macOS but again it will most likely not work.

    * Check [2. iOS](#manual-setup) and [3. macOS](#manual-setup) sections in manual setup for a bit more details.


## Manual Setup
**In case the automated script didn't work or you want to configure this template manually, this will be the place where you will find how to configure for most platforms in detail.**

1. Android <br>
    - Change application ID
        * In `/android/app/proguard-rules.pro` change **com.example.fluttertemplate** from <br> 

            ```pro
            -keep class com.example.fluttertemplate.** { *; }
            ```
            to your application ID.
        
        <br>

        * In `/android/app/build.gradle.kts` change **com.example.fluttertemplate** from <br> 

            ```kts
            // TODO: change this to your application's package name
            namespace = "com.example.fluttertemplate"
            ```
            and
        
            ```kts
            // TODO: change this to your application's package name
            applicationId = "com.example.fluttertemplate"
            ```

            to your application ID.

        <br>

        * In `/android/app/src/main/kotlin/com/example/fluttertemplate/MainActivity.kt` change **com.example.fluttertemplate** from <br>

            ```kt
            package com.example.fluttertemplate
            ```
            to your application ID.
        <br>
        <br>

        **VERY IMPORTANT**

        Make sure to rename the folders **/com/example/fluttertemplate** to match your application ID.
      
        For example, if your application ID is `com.mycompany.myapp`, rename the folders to **/com/mycompany/myapp** accordingly.
      
        Also, ensure that the folder still contains the **MainActivity.kt** file after renaming.

        <br>
    
    - Change app name
        * In `/android/app/src/main/AndroidManifest.xml` change **flutter_template** from <br>

            ```xml
            android:label="flutter_template"
            ```
            to your app's name.

        <br>

    - Generate the keystore
        * Run this command in a cmd or terminal and follow instructions:

            ```bash
            keytool -genkeypair -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload_key
            ```

        **Don't forget** the **password** as you will need it again and **don't use symbols** as it might cause **errors**.

        * Move the `release.jks` that was generated (in the directory you ran the command) into `/android/app/`

    - Create key.properties
        * In `/android/` make a file called **key.properties**

        * Inside the file paste this inside:

            ```text
            storeFile=release.jks
            storePassword=PASSWORD
            keyAlias=upload_key
            keyPassword=PASSWORD
            ```

            and **replace** `PASSWORD` with the **same** password you used while **generating** the keystore.

    **Don't worry about publishing `key.properties` or `release.jks` to GitHub because they are added inside `.gitignore`**.

    <br>

2. iOS <br>
    - check [the official links](https://docs.flutter.dev/deployment/ios) from flutter since iOS is a bit more complicated to set up.

3. macOS <br>
    - check [the official links](https://docs.flutter.dev/deployment/macos) from flutter since macOS is a bit more complicated to set up.

4. Windows <br>
    - Change app name
        * In `/windows/runner/main.cpp` change **flutter_template** from <br>

            ```cpp
            if (!window.Create(L"flutter_template", origin, size)) {
            return EXIT_FAILURE;
            }
            ```
        
            with your app's name.

5. Linux <br>
    - Change app name
        * In `/linux/runner/my_application.cc` change **flutter_template** from<br>

            ```cc
            if (use_header_bar) {
            GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
            gtk_widget_show(GTK_WIDGET(header_bar));
            gtk_header_bar_set_title(header_bar, "flutter_template");
            gtk_header_bar_set_show_close_button(header_bar, TRUE);
            gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
            } else {
            gtk_window_set_title(window, "flutter_template");
            }
            ```
            to your app's name.

6. Web <br>
    - Change app name
        * In `/web/index.html` change **flutter_template** from <br>
        
            ```html
            <title>flutter_template</title>
            ```
            to your app's name.


## App icon
**To set up an icon for your app is very easy**
1. Open `pubspec.yaml` file from the root of your project.

2. Find the part:
```yaml
# Make sure to edit as needed (for app icon)
# I recommend https://easyappicon.com/ to generate an 512x512 PNG icon
icons_launcher:
  image_path: "assets/app-icon/app_icon.png"
  platforms:
    android:
      enable: true
      image_path: "assets/app-icon/app_icon.png"
    ios:
      enable: true
      image_path: "assets/app-icon/app_icon.png"
    web:
      enable: true
      image_path: "assets/app-icon/app_icon.png"
      favicon_path: "assets/app-icon/app_icon.png"
    macos:
      enable: true
      image_path: "assets/app-icon/app_icon.png"
    windows:
      enable: true
      image_path: "assets/app-icon/app_icon.png"


# after editing the above sections, run the following commands to apply changes:

# flutter pub get && dart run icons_launcher:create

```

3. Generate an 512x512 PNG icon.
    - **Prepare** the image you want to use as your **app icon**, then open https://easyappicon.com/ in your web browser.
    
    - **Upload** the image.

    - Change **size** based on your image.

    - Change **background color** if needed.

    - **Download** (make sure format is set as `png`)

4. **Extract** the zip that was downloaded and open the **android** folder inside

5. **Find** the `ic_launcher-web.png` and rename it to `app_icon.png`

6. **Replace** the default **app_icon.png** from `/assets/app-icon/app_icon.png` with the one you just generated.

7. To update the app icon run the commands in your IDE's terminal or in any terminal inside the root of your project and run:
```bash
flutter pub get && dart run icons_launcher:create
```

8. Done!

## Splash screen
My preference for splash screens is to use the same app-icon and only configure the background color, but you can checkout https://pub.dev/packages/flutter_native_splash which has documentation on how to configure it, and make it as you like.

1. Open `pubspec.yaml` file from the root of your project.

2. Find the part:
```yaml
# Make sure to edit as needed (for splash screen)
flutter_native_splash:
  image: assets/app-icon/app_icon.png  # Path to splash image (general)
  color: "#FFFFFF"                     # Splash screen background color
  icon_background_color: "#FFFFFF"    # Background color behind the splash icon
  android_12:
    image: assets/app-icon/app_icon.png   # Path to splash image for android
    color: "#FFFFFF"                   # Splash color for Android 12+
    icon_background_color: "#FFFFFF"
  ios: true                           # Enable splash screen on iOS
  web: true                           # Enable splash screen on web

# after editing the above sections, run the following commands to apply changes:

# flutter pub get && dart run flutter_native_splash:create
```

3. To update the splash screen run the commands in your IDE's terminal or in any terminal inside the root of your project and run:

```bash
flutter pub get && dart run flutter_native_splash:create
```

4. To remove and return to default:

```bash
dart run flutter_native_splash:remove
```

5. Done!



## Project structure

The folder structure is located in `/lib` by default, supporting both desktop and mobile. Delete the desktop or mobile folders if you do not need them.

* First in the main function in `main.dart` it loads: `AppLayout()` which decides based on the width of the screen if it should build the *Mobile* or *Desktop* UI. If it's desktop it builds: `MainScreenDesktop()` and if it's mobile it builds: `MainScreenMobile()`.

* Then `MainScreenDesktop()` and `MainScreenMobile()` can be your entry for your app. For example `MainScreenMobile()` can be where you can have your pages and have the app bar and bottom navigation bar for your app as it is already done for you.



## Adding and removing platforms

1. Adding <br>
    - Run the following commands from the **root folder** of your project to add platforms:

    ```bash
    flutter create . --platforms=windows
    flutter create . --platforms=linux
    flutter create . --platforms=android
    flutter create . --platforms=web
    flutter create . --platforms=macos
    flutter create . --platforms=ios
    ```

2. Removing <br>
    - To remove a platform all you have to do is delete that folder.
    - For example if you don't want Linux supported in your project delete the `/windows/` folder inside your **root folder**


## Automated release
After you have created your app you can **easily** make it available for release **(share it)** by using the `build.sh` script that is located in `scripts/build.sh`.

1. Make sure you have the required tools downloaded for your specific platform [here](#required-tools).

2. Open the `build.sh` script and read the comments at the start which will help you to know what to modify based on your OS and needs.

3. If you think that it's hard to understand what you have to do here is a short list:

    Globally used
    - **APP_VERSION="1.0.0+1"** This will be the version used for your app across **all platforms**, change at every release.

    - **APP_NAME="Flutter Template"** This will be the display name for your app for **Windows/Linux/macOS**, it's used by Inno Setup (for Windows) and by Linux and macOS by desktop entries.

    Linux/macOS specific
    - **APP_DESCRIPTION="A Flutter template..."** This will be the description used by desktop entries for **Linux and macOS**.

    - **APP_TERMINAL="flutter-template"** This will be the command that people who install your app via the installer.sh on **Linux and macOS** will be able to use to start your app from the terminal.

    Windows specific
    - **APP_PUBLISHER="euhfs"** This will be used by the Inno Setup installer and app metadata on Windows.

    - **APP_URL="https://github.com/euhfs/flutter_template"** This is the website or GitHub repository that people can visit for more information.

    - **APP_ID="{{5193F39C-8C38-41CF-93C2-07F401FB0530}}"** This will be the unique ID for your app (like application ID on android). Check script on how to get another ID using Inno Setup.

    - For Windows you also need to make sure your Inno Setup **path** is correct.

    Linux specific
    - For Linux you also need to make sure your appimagetool **path** is correct.

4. I still REALLY recommend to read through the start of the build script to understand correctly and make sure everything is set up right.

5. This script will check if you are on Windows/Linux/macOS and adjust available build platforms.
    - **Linux:** `Linux, Android, Web`

    - **Windows:** `Windows, Android, Web`

    - **macOS:** `macOS, iOS, Android, Web`

## Manual release

1. Android <br>
    For android it's really easy, in the root folder, run in the terminal:

    - For an universal apk (can be run on any android device but big in size)

        ```bash
        flutter build apk --release
        ```
    - For multiple smaller apk's (smaller in size but doesn't run on any android device)

        ```bash
        flutter build apk --release --split-per-abi
        ```

    - For one universal appbundle that is used by google play or via bundletool

        ```bash
        flutter build aab
        ```

2. Windows <br>
    Base command:

    ```bash
    flutter build windows --release
    ```

    For Windows it is a bit more complicated, for publishing on the microsoft store check the official flutter documentation.

    For publishing everywhere else, Inno Setup is recommended.

    To do that make sure you have Inno Setup installed and I recommend this tutorial on how to use it:

    https://youtu.be/XvwX-hmYv0E?si=u-BvX0Uaj98f_Lrc

    If you don't want to open this link, search on youtube: Flutter app with Inno Setup

3. Linux <br>
    Base command:

    ```bash
    flutter build linux --release
    ```

    The official flutter documentation recommends using snap to make your project work on most Linux distributions.
    
    I like to use .AppImages since they can be run on all linux distributions and it's only one executable, simple to run.

    I recommend this tutorial on how to make an .AppImage

    https://youtu.be/htXS9Ps4lq0?si=-VCSbFRX3tJY79X2

    or

    https://docs.flutter.dev/deployment/linux

    which is the official documentation, on how to build and release an linux app using snap.

4. Web <br>
    Base command:

    ```bash
    flutter build web --wasm --release
    ```

    This will give you all files needed check [publishing](#publishing) on how to make it an website or integrate it into one.

## Publishing
After you ran the build script the release outputs based on your OS will be located by default in `Documents/flutter/release`. There you will find your project's name with folder like Android, Web etc. This section will only include instructions if you used the script, not if you did manually.

1. Android <br>
    - Find the `android` folder inside `Documents/flutter/release/yourproject/android`, inside there you will have:
        * An universal apk which can be run on any android device but bigger in size.
        
        * An arm64.apk which will run on most modern android devices, smaller in size.

        * An armeabi-v7a.apk which will run on older android devices, smaller in size.

        * x86-64.apk which will run on android emulators, smaller in size.

        * .aab which will mostly be used by google play or installed on devices via bundletool.

2. Windows <br>
    - Find the `windows` folder inside `Documents/flutter/release/yourproject/windows`, inside there you will have:
        * Only an exe named after your project, which you can share to anyone that has a Windows machine and will be able to install/uninstall and use your app easily.

3. Linux <br>
    - Find the `linux` folder inside `Documents/flutter/release/yourproject/linux`, inside there you will have:
        * An .AppImage which is the main app executable.

        * An .png which is used for the app icon in desktop entries.

        * An install.sh script which users can run to install the app in their system and create an desktop entry + run by terminal.

        * An uninstaller.sh script which users can run to uninstall the app from their system.

4. Web <br>
    - Find the `web` folder inside `Documents/flutter/release/yourproject/web`, inside there you will have the index.html and everything needed to either make it an entire app or integrate into an website. I recommend watching an tutorial on how to do that.

# License
This project template is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.