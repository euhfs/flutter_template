## Introduction

This Flutter project template helps you build and release apps fast. It’s made for developers who want to focus on building their app, not wasting time setting it up.

The template runs best on Linux, Android, Web, and Windows.

It includes step-by-step setup and release scripts that automate everything—from configuration to app icon setup. You can do it manually if you prefer, but the scripts are faster and easier.

Using the scripts, you can have your app ready in under 30 minutes. Once familiar, setup takes about 10 minutes.

For iOS/macOS deployment, check Flutter’s official documentation:
https://docs.flutter.dev/deployment


## Table of contents

- [**Quick Start**](#quick-start)
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
- [**Issues**](#issues)
- [**Tasks**](#tasks)
- [**License**](#license)

## Quick start
* Windows (Git Bash):

    ```bash
    winpty curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && ./setup.sh
    ```
    
* Linux/macOS:
    ```bash
    curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && chmod +x setup.sh && ./setup.sh
    ```


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
**This section shows how to download and build the project so you can turn it into your own template.**

The `setup.sh` script automatically handles default paths for Windows, Linux, and more. Do not manually change paths, app IDs, or other values unless you know what you’re doing. The script manages all configurations for you if you just use it.

1. Download
    1. Click the **green** Code button and select “Download ZIP”, **or**

    2. **Clone** the repository

        ```bash
        git clone https://github.com/euhfs/flutter_template.git
        ```

2. Setup
    1. **Modify** the template to fit your needs. **Only** change files inside the lib folder. Check [project structure](#project-structure) to see how everything works.

    2. You can either **manually** download your template each time, or make it work with the `setup.sh` and `build.sh` scripts.

3. Configure scripts
    1. Publish your modified template on GitHub first. **Public** is recommended; private repos can cause permission **issues**.

    2. In `setup.sh`, edit the **REPO_URL** variable and set it to your repository.

    3. In `build.sh`, adjust the variables as needed. Details are explained at the **start** of the **script**.


## Automated Setup

1. Windows <br>
    **(To paste in the terminal use right click)**
    1. Open Git Bash and go to your preferred directory, for example:

        ```bash
        cd ~/Documents
        ```

    2. Run the setup script:

        ```bash
        winpty curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && ./setup.sh
        ```

    3. Follow the prompts:
        * `Enter the name for the main folder:` (e.g. password_generator)

        * `Enter the location where it should be installed:` (leave blank to use Downloads or specify a path like **C:\Users\YOURUSER\Documents\MyProjects**).

        * `Enter the display name for your app:` (e.g., Password Generator).

        * `Enter package name:` in reverse domain format (e.g., com.euhfs.passwordgenerator).

        * Decide whether to set up the Android keystore (y/n).
            * If yes, provide your company or developer name and a password. The name is not that important, but the password is. **Don't** lose it.
        
        * Once **finished**, the template will include folders for all platforms. **Delete** any you don’t plan to use, such as **Linux or iOS**. You can still enable them later, but you’ll need to update app names **manually**.

2. Linux <br>
    1. Open your terminal and go to your preferred directory:
        
        ```bash
        cd ~/Documents
        ```

    2. Run the setup script:

        ```bash
        curl -o setup.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/setup.sh && chmod +x setup.sh && ./setup.sh
        ```

    3. Follow the same instructions as for Windows.
        * Leave the install location blank to use Downloads or enter a path like `/home/YOURUSER/Documents/MyProjects`.

3. macOS <br>
    **Setup is mostly the same as linux**

    * The script will **attempt** to update **bundle identifiers** and **app names** for **iOS** and **macOS**, but results may vary since it **hasn’t** been tested on macOS. It **will** still work for android and web.

    * If it fails, refer to the [manual setup](#manual-setup) sections for iOS and macOS


## Manual Setup
**Use these steps if the automated setup failed, or if you prefer setting things up manually.**

1. Android <br>
    1. Change the application ID
        * Open `/android/app/proguard-rules.pro` and replace:

            ```pro
            -keep class com.example.fluttertemplate.** { *; }
            ```

            with your own application ID.
        
        <br>

        * In `/android/app/build.gradle.kts`, replace:

            ```kts
            namespace = "com.example.fluttertemplate"
            applicationId = "com.example.fluttertemplate"
            ```

            with your application ID.

        <br>

        * In `/android/app/src/main/kotlin/com/example/fluttertemplate/MainActivity.kt`, replace:

            ```kt
            package com.example.fluttertemplate
            ```
            to your application ID.
        <br>
        <br>

        **VERY IMPORTANT**

        Rename the folder structure under `/com/example/fluttertemplate` to match your new ID.
      
        For example, if your application ID is `com.mycompany.myapp`, rename the folders to **/com/mycompany/myapp** accordingly.
      
        Keep MainActivity.kt inside the new folder.

        <br>
    
    2. Change app name
        * In `/android/app/src/main/AndroidManifest.xml`, update:

            ```xml
            android:label="flutter_template"
            ```
            to your app name.

        <br>

    3. Generate the keystore
        * Run:

            ```bash
            keytool -genkeypair -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload_key
            ```

        **Avoid** using symbols in the password. Move the generated `release.jks` into `/android/app/`.

    4. Create key.properties
        * Inside `/android/` create a file named **key.properties** with:

            ```text
            storeFile=release.jks
            storePassword=PASSWORD
            keyAlias=upload_key
            keyPassword=PASSWORD
            ```

            Replace `PASSWORD` with the one you used when generating the keystore.

    **`release.jks` and `key.properties` are added in `.gitignore`, so they won't be uploaded to GitHub.**.

    <br>

2. iOS <br>
    - check [Flutter's official iOS](https://docs.flutter.dev/deployment/ios) setup guide.


3. macOS <br>
    - check [Flutter's official macOS](https://docs.flutter.dev/deployment/macos) setup guide.


4. Windows <br>
    * In `/windows/runner/main.cpp`, replace:

        ```cpp
        if (!window.Create(L"flutter_template", origin, size)) {
        return EXIT_FAILURE;
        }
        ```
        with your app name.

5. Linux <br>
    * In `/linux/runner/my_application.cc`, replace:

        ```cc
        gtk_header_bar_set_title(header_bar, "flutter_template");
        gtk_window_set_title(window, "flutter_template");
        ```
        with your app name.
    

6. Web <br>
    * In `/web/index.html`, replace:

        ```html
        <title>flutter_template</title>
        ```
        with your app name.


## App icon
**Set up an icon easily**
1. **Open** `pubspec.yaml`.

2. **Find:**

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

7. **Apply changes**:

    ```bash
    flutter pub get && dart run icons_launcher:create
    ```


## Splash screen
Use the app icon for your splash screen, or customize it using the flutter_native_splash package.

1. **Open** `pubspec.yaml`.

2. **Find:**

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

3. **Apply changes**:

    ```bash
    flutter pub get && dart run flutter_native_splash:create
    ```

4. To **remove** and revert to default:

    ```bash
    dart run flutter_native_splash:remove
    ```


## Project structure

The folder structure is located in `/lib` by default, supporting both desktop and mobile. Delete the desktop or mobile folders if you do not need them.

* The main function in `main.dart` loads `AppLayout()`, which switches between desktop and mobile layouts.

* `MainScreenDesktop()` and `MainScreenMobile()` are your starting points for each platform. For example, `MainScreenMobile()` can handle navigation and layout for your mobile app.



## Adding and removing platforms

1. Adding <br>
    - Run the following commands:

    ```bash
    flutter create . --platforms=windows
    flutter create . --platforms=linux
    flutter create . --platforms=android
    flutter create . --platforms=web
    flutter create . --platforms=macos
    flutter create . --platforms=ios
    ```

2. Removing <br>
    - To remove a platform you have to delete the folder.

    - For example, delete `linux` folder if you don't want it supported in your project.


## Automated release
After you have created your app you can **easily** make it available for release **(share it)** by using the `build.sh` script that is located in `scripts/build.sh`.

1. Make sure you have the required tools downloaded for your specific platform [here](#required-tools).

2. Open the `build.sh` script, there you will have information in detail on how, and what to change.

3. Here is an overview:

    Globally used
    - **APP_VERSION="1.0.0+1"** Version number.

    - **APP_NAME="Flutter Template"** Display name **only** for Linux/macOS desktop entries.

    Linux/macOS specific
    - **APP_DESCRIPTION="A Flutter template..."** Description for desktop entries, **only** Linux/macOS.

    - **APP_TERMINAL="flutter-template"** Command to run app from terminal, only when users use the `install.sh` script.

    Windows specific
    - **APP_PUBLISHER="euhfs"** Your name or company.

    - **APP_URL="https://github.com/euhfs/flutter_template"** Your website.

    - **APP_ID="{{5193F39C-8C38-41CF-93C2-07F401FB0530}}"** Unique identifier for your app. Use Inno Setup tools tab to generate a new GUID.

    - For Windows you also need to make sure your Inno Setup **path** is correct.

    Linux specific
    - For Linux you also need to make sure your appimagetool **path** is correct.

4. This script will check if you are on Windows/Linux/macOS and adjust available build platforms.
    - **Linux:** `Linux, Android, Web`

    - **Windows:** `Windows, Android, Web`

    - **macOS:** `macOS, iOS, Android, Web`

## Manual release

1. Android <br>
    To build for Android, run:

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
    
    I usually use .AppImages since they can be run on all linux distributions and it's only one executable, simple to run.

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

    This will give you all files needed to make or integrate it into an website.

## Publishing
After you ran the build script the release outputs based on your OS will be located by default in `Documents/flutter/release`. There you will find your project's name with folder like Android, Web etc. This section will **only** include instructions if you used the script, not if you did manually.

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


## Issues


Track bugs and feature requests using **GitHub Issues**. Please **describe** problems **clearly** and check **existing** issues before opening a new one.


## Tasks


* Make a demo app for mobile/desktop also using core
* Cleaner structure
* Cleaner app theme + colors


# License
This project template is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.