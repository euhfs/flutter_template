#!/bin/bash

# THIS WORKS ON LINUX ONLY
# not sure about macos

# How to run:
## Run in terminal: scripts/build.sh
## If it doesn't work make sure it has the right permissions to run: chmod +x scripts/build.sh
## First make sure you have the folder flutter inside Documents and add appimagetool-x86_64.AppImage install it from: https://github.com/AppImage/appimagetool/releases
## MAKE SURE YOU GET THE appimagetool-x86_64.AppImage and don't rename it

# Important for linux:
## Create an .env file inside the root project and add information about your app:
##APP_NAME="Flutter Template"
##APP_DESCRIPTION="A flutter template helpful to make building apps easier"
##APP_TERMINAL="flutter-template"

# For the env you can just rename .envtest to .env.
## I did it like that just so you don't use it for actual important API's and so on and to not remove .env from .gitignore in case you decide to use it
## If you don't rename it to .env you might get an error

## APP_NAME is just the display name of your app
## APP_DESCRIPTION is the description under the display name of the app
## APP_TERMINAL is the command you run from terminal to open the app (useful to have)

# What this does:
## It gets the app in in this repository and creates an folder inside Documents named flutter
## Inside that folder you will find 3 folders but the only one you need is RELEASE where you will find the project name and inside 3 other folders (if you ran "all" in the script), as android, web, and linux. Linux is packaged as an appimage, you can zip the linux folder and anyone can install it and run the installer to have the app installed on their system.
## For android you just have the apk's for each architecture or an universal apk which works on all android devices
## And same for the web, it has everything it needs, if you want to make the app as an website you can search for tutorials on youtube on how to use it with github pages or integrate it inside a website as demo.

# ============================================================
# LOAD ENVIRONMENT VARIABLES
# ============================================================

PROJECT_NAME=$(basename "$PWD")

if [ -f .env ]; then
    source .env
else
    echo ".env file not found! Please create one before building."
    exit 1
fi

if [ -z "$APP_NAME" ] || [ -z "$APP_DESCRIPTION" ] || [ -z "$APP_TERMINAL" ]; then
    echo "Missing required variable(s) in .env file!"
    exit 1
fi

# ============================================================
# PATHS AND DIRECTORIES
# ============================================================

OUTPUT_DIR="$HOME/Documents/outputs/$PROJECT_NAME"
RELEASE_DIR="$HOME/Documents/release/$PROJECT_NAME"
BUILD_DIR="$PWD/build"

APKBUILD_DIR="$BUILD_DIR/app/outputs/flutter-apk"
LINUXBUILD_DIR="$BUILD_DIR/linux/x64/release/bundle"
WEBBUILD_DIR="$BUILD_DIR/web"

APPIMAGETOOL="$HOME/Documents/appimagetool-x86_64.AppImage"

ICON_PATH="./assets/app-icon/app_icon.png"

# Create required directories
mkdir -p "$OUTPUT_DIR/android" "$OUTPUT_DIR/linux" "$OUTPUT_DIR/web"
mkdir -p "$RELEASE_DIR/android" "$RELEASE_DIR/linux" "$RELEASE_DIR/web"

# ============================================================
# BUILD COMMANDS
# ============================================================

BUILD_APK="flutter build apk --release --split-per-abi"
BUILDUNI_APK="flutter build apk --release"
BUILD_LINUX="flutter build linux --release"
BUILD_WEB="flutter build web --wasm --release"

# ============================================================
# HELPER FUNCTION
# ============================================================

copy_file() {
    src="$1"
    dest="$2"
    if cp -r "$src" "$dest"; then
        echo "Copied $src → $dest ✅"
    else
        echo "Failed to copy $src ❌"
    fi
}

# ============================================================
# BUILD SECTIONS
# ============================================================

build_android() {
    echo "Building Android..."
    $BUILD_APK
    $BUILDUNI_APK

    copy_file "$APKBUILD_DIR/app-armeabi-v7a-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_armeabi-v7a.apk"
    copy_file "$APKBUILD_DIR/app-arm64-v8a-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_arm64.apk"
    copy_file "$APKBUILD_DIR/app-x86_64-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_x86-64.apk"
    copy_file "$APKBUILD_DIR/app-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_universal.apk"

    mkdir -p "$RELEASE_DIR/android/"
    cp -r "$OUTPUT_DIR/android/"* "$RELEASE_DIR/android/"
    echo "Android build completed."
}

build_linux() {
    echo "Building Linux..."
    $BUILD_LINUX

    cp -r "$LINUXBUILD_DIR" "$OUTPUT_DIR/linux/"
    mkdir -p "$HOME/Documents/build/$PROJECT_NAME/AppDir"

    cp -r "$OUTPUT_DIR/linux/bundle/"* "$HOME/Documents/build/$PROJECT_NAME/AppDir/"
    
    # Copy icon from fixed path without using APP_ICON_LOCATION variable
    if [ ! -f "$ICON_PATH" ]; then
        echo "Error: Icon file not found at $ICON_PATH"
        exit 1
    fi
    cp "$ICON_PATH" "$HOME/Documents/build/$PROJECT_NAME/AppDir/.DirIcon.png"

    chmod +x "$HOME/Documents/build/$PROJECT_NAME/AppDir/$PROJECT_NAME"

    cat <<EOF > "$HOME/Documents/build/$PROJECT_NAME/AppDir/AppRun"
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\$HERE/$PROJECT_NAME" "\$@"
EOF
    chmod +x "$HOME/Documents/build/$PROJECT_NAME/AppDir/AppRun"

    cat <<EOF > "$HOME/Documents/build/$PROJECT_NAME/AppDir/$PROJECT_NAME.desktop"
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=AppRun
Icon=.DirIcon
Comment=$APP_DESCRIPTION
Categories=Utility;
Terminal=false
EOF

    mkdir -p "$RELEASE_DIR/linux/"
    ARCH="x86_64" "$APPIMAGETOOL" "$HOME/Documents/build/$PROJECT_NAME/AppDir" "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"
    chmod +x "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"
    cp "$HOME/Documents/build/$PROJECT_NAME/AppDir/.DirIcon.png" "$RELEASE_DIR/linux/$PROJECT_NAME.png"

    # Create uninstall script
    cat <<EOF > "$RELEASE_DIR/linux/uninstaller.sh"
#!/bin/bash
APP_NAME="$APP_NAME"
APP_DIR="/opt/$PROJECT_NAME"
APPIMAGE_NAME="$PROJECT_NAME.AppImage"
DESKTOP_FILE="\$HOME/.local/share/applications/$PROJECT_NAME.desktop"
ICON_FILE="\$HOME/.local/share/icons/$PROJECT_NAME.png"
SYMLINK="/usr/local/bin/$PROJECT_NAME"
echo "Uninstalling \$APP_NAME..."
if [ -d "\$APP_DIR" ]; then sudo rm -rf "\$APP_DIR"; fi
if [ -f "\$DESKTOP_FILE" ]; then rm "\$DESKTOP_FILE"; fi
if [ -f "\$ICON_FILE" ]; then rm "\$ICON_FILE"; fi
if [ -L "\$SYMLINK" ]; then sudo rm "\$SYMLINK"; fi
if command -v update-desktop-database >/dev/null; then update-desktop-database "\$HOME/.local/share/applications"; fi
echo "\$APP_NAME uninstalled."
EOF
    chmod +x "$RELEASE_DIR/linux/uninstaller.sh"

    # Create install script
    cat <<EOF > "$RELEASE_DIR/linux/install.sh"
#!/bin/bash
APP_NAME="$APP_NAME"
APP_DIR="/opt/$PROJECT_NAME"
APPIMAGE_NAME="$PROJECT_NAME.AppImage"
DESKTOP_FILE="\$HOME/.local/share/applications/$PROJECT_NAME.desktop"
ICON_FILE="\$HOME/.local/share/icons/$PROJECT_NAME.png"
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
ICON_PATH="\$SCRIPT_DIR/$PROJECT_NAME.png"
sudo mkdir -p "\$APP_DIR"
sudo cp "\$APPIMAGE_NAME" "\$APP_DIR/"
sudo chmod +x "\$APP_DIR/\$APPIMAGE_NAME"
sudo cp "\$SCRIPT_DIR/uninstaller.sh" "\$APP_DIR/uninstaller.sh"
sudo chmod +x "\$APP_DIR/uninstaller.sh"
sudo ln -sf "\$APP_DIR/\$APPIMAGE_NAME" "/usr/local/bin/$APP_TERMINAL"
mkdir -p "\$(dirname "\$DESKTOP_FILE")"
cat > "\$DESKTOP_FILE" <<DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=\$APP_NAME
Exec=\$APP_DIR/\$APPIMAGE_NAME
Icon=\$ICON_FILE
Comment=$APP_DESCRIPTION
Categories=Utility;
Terminal=false
DESKTOP_EOF
mkdir -p "\$(dirname "\$ICON_FILE")"
cp "\$ICON_PATH" "\$ICON_FILE"
if command -v update-desktop-database >/dev/null; then update-desktop-database "\$HOME/.local/share/applications"; fi
echo "Installation complete! Run '$APP_TERMINAL' to start."
EOF
    chmod +x "$RELEASE_DIR/linux/install.sh"

    echo "Linux build completed."
}

build_web() {
    echo "Building Web..."
    $BUILD_WEB
    cp -r "$WEBBUILD_DIR/"* "$OUTPUT_DIR/web/"
    mkdir -p "$RELEASE_DIR/web/"
    cp -r "$OUTPUT_DIR/web/"* "$RELEASE_DIR/web/"
    echo "Web build completed."
}

# ============================================================
# MAIN EXECUTION
# ============================================================

echo "Enter platform to build (android, linux, web, or all):"
read PLATFORM

case "$PLATFORM" in
    android)
        build_android
        ;;
    linux)
        build_linux
        ;;
    web)
        build_web
        ;;
    all)
        build_android
        build_linux
        build_web
        ;;
    *)
        echo "Invalid option."
        ;;
esac
