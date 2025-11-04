#!/usr/bin/env bash

# THIS WORKS ON LINUX ONLY FOR NOW
# If you have a macos I'm not sure if it works, I don't have a mac but I will try to make it work
# If you are on windows this is not supported yet, but if it will be supported you will most likely need to use mingw, msys, or cygwin (I don't want to make another script in powershell because it would be complicated and it's better to have everything in one place.

# How to run:
## Run in terminal: scripts/build.sh
## If it doesn't work make sure it has the right permissions to run: chmod +x scripts/build.sh
## First make sure you have the folder flutter inside (Documents/flutter) or edit the path, and add appimagetool-x86_64.AppImage install it from: https://github.com/AppImage/appimagetool/releases
## MAKE SURE YOU GET THE appimagetool-x86_64.AppImage and don't rename it, or change the appimage path


# Important for linux:
## Edit these variables below in "PATHS AND DIRECTORIES + VARIABLES"

## APP_NAME is just the display name of your app
## APP_DESCRIPTION is the description under the display name of the app
## APP_TERMINAL is the command you run from terminal to open the app (useful to have)


# What this does:
## It gets the app in in this repository and creates an folder inside Documents named flutter (Or your path in case you changed it)
## Inside that folder you will find 3 folders but the only one you need is RELEASE where you will find the project name and inside 3 other folders (if you ran "all" in the script), named: android, web, and linux. Linux is packaged as an appimage, you can zip the linux folder and anyone can install it and use it like this: extract folder (if you made it .zip) cd into it, and run the installer script.
## For android you just have the apk's for each architecture or an universal apk which works on all android devices (you can change the script if you only want an .aab or universal apk as you like.
## And same for the web, it has everything it needs, if you want to make the app as an website you can search for tutorials on youtube on how to use it with github pages or integrate it inside a website as demo.


# ============================================================
# PATHS + DIRECTORIES + VARIABLES
# ============================================================

PROJECT_NAME=$(basename "$PWD") # I do not recommend changing this, leaving it as the root's directory name is the best idea to make sure everything works right and you have no errors.


# Variables (ONLY NEEDED FOR LINUX BUILD, LEAVE AS IT IS IF YOU DON'T BUILD FOR LINUX)
APP_NAME="Flutter Template" # This will be the name of your linux app.
APP_DESCRIPTION="A flutter template useful for building apps easier." # This will be the description of your linux app.
APP_TERMINAL="flutter-template" # This will be the command that you can use to run your app from terminal.

APPIMAGETOOL="$HOME/Documents/flutter/appimagetool-x86_64.AppImage" # Change to your appimage tool path as needed.
ICON_PATH="./assets/app-icon/app_icon.png" # Change to your icon path as needed.


# Modify these with the location where you wish the directories to be located.
OUTPUT_DIR="$HOME/Documents/flutter/outputs/$PROJECT_NAME" # This is where all the files/folders will go when you build your project.
RELEASE_DIR="$HOME/Documents/flutter/release/$PROJECT_NAME" # This is where all the final outputs will be located when everything is finished, these are the files/folders you can use to share your app.
LINUX_BUILD_DIR="$HOME/Documents/flutter/build/$PROJECT_NAME" # This will be where your linux app will make the AppDir folder (used to prepare the final .AppImage output).


# Don't need to modify these since they are project wise.
BUILD_DIR="$PWD/build"
APKBUILD_DIR="$BUILD_DIR/app/outputs/flutter-apk"
LINUXBUILD_DIR="$BUILD_DIR/linux/x64/release/bundle"
WEBBUILD_DIR="$BUILD_DIR/web"

# LINUX_BUILD_DIR and LINUXBUILD_DIR have confusing names but I couldn't think of any better name for it. LINUXBUILD_DIR is where the files from running flutter build linux will go and LINUX_BUILD_DIR is where the output AppDir directory will be located, I only recommend to change LINUX_BUILD_DIR as the other 2 above it (OUTPUT_DIR, RELEASE_DIR).

# Create required directories
mkdir -p "$OUTPUT_DIR/android" "$OUTPUT_DIR/linux" "$OUTPUT_DIR/web"
mkdir -p "$RELEASE_DIR/android" "$RELEASE_DIR/linux" "$RELEASE_DIR/web"




# ============================================================
# CHECK OS
# ============================================================


OS_TYPE="$(uname | tr '[:upper:]' '[:lower:]')"
case "$OS_TYPE" in
    linux*)
        PLATFORM="linux"
        echo "Running on Linux"
        ;;
    darwin*)
        PLATFORM="macos"
        echo "Running on macOS"
        ;;
    mingw*|msys*|cygwin*)
        PLATFORM="windows"
        echo "Running on Windows (via MinGW/Cygwin/MSYS)"
        ;;
    *)
        echo "Unsupported OS: $OS_TYPE"
        exit 1
        ;;
esac


# ============================================================
# CHECK IF FLUTTER IS INSTALLED
# ============================================================


command -v flutter >/dev/null 2>&1 || { echo >&2 "Flutter is required but not installed. Aborting."; exit 1; }


# ============================================================
# FUNCTIONS FOR SUPPORTED BUILD PLATFORMS ON EACH OS
# ============================================================

# Available platforms for linux
linux_build_platforms() {

echo "linux android web all"

}


# Available platforms for windows
windows_build_platforms() {

echo "windows android web all"

}


# Available platforms for macos
macos_build_platforms() {

echo "macos ios android web all"

}


# ============================================================
# BUILD COMMANDS
# ============================================================


# These are the command that will be used to build the flutter app in your project
BUILD_APK="flutter build apk --release --split-per-abi"
BUILDUNI_APK="flutter build apk --release"
BUILD_LINUX="flutter build linux --release"
BUILD_WEB="flutter build web --wasm --release"


# ============================================================
# HELPER FUNCTION
# ============================================================


# Just a helper function to help copying files
copy_file() {
    src="$1"
    dest="$2"
    if ! cp -r "$src" "$dest"; then
        echo "Failed to copy $src to $dest" >&2
        exit 1
    else
        echo "Copied $src → $dest ✅"
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
    mkdir -p "$LINUX_BUILD_DIR/AppDir"

    cp -r "$OUTPUT_DIR/linux/bundle/"* "$LINUX_BUILD_DIR/AppDir/"
    
    # Copy icon from fixed path without using APP_ICON_LOCATION variable
    if [ ! -f "$ICON_PATH" ]; then
        echo "Error: Icon file not found at $ICON_PATH"
        exit 1
    fi

    cp "$ICON_PATH" "$LINUX_BUILD_DIR/AppDir/.DirIcon.png"

    chmod +x "$LINUX_BUILD_DIR/AppDir/$PROJECT_NAME"

    # Create AppRun file inside AppDir
    cat <<EOF > "$LINUX_BUILD_DIR/AppDir/AppRun"
#!/usr/bin/env bash
HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\$HERE/$PROJECT_NAME" "\$@"
EOF
    
    # Give the file permission to run.
    chmod +x "$LINUX_BUILD_DIR/AppDir/AppRun"

    # Create the .desktop file.
    cat <<EOF > "$LINUX_BUILD_DIR/AppDir/$PROJECT_NAME.desktop"
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=AppRun
Icon=.DirIcon
Comment=$APP_DESCRIPTION
Categories=Utility;
Terminal=false
EOF
    # Make sure the linux release directory exists, if not create it.
    mkdir -p "$RELEASE_DIR/linux/"

    # Run the command to build the .AppImage and move it to the release directory.
    ARCH="x86_64" "$APPIMAGETOOL" "$LINUX_BUILD_DIR/AppDir" "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"

    # Give it permission to run.
    chmod +x "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"
    cp "$LINUX_BUILD_DIR/AppDir/.DirIcon.png" "$RELEASE_DIR/linux/$PROJECT_NAME.png"

    # ONLY FOR LINUX
    # Create uninstall script. (Really useful so users can uninstall your app using the script.
    cat <<EOF > "$RELEASE_DIR/linux/uninstaller.sh"
#!/usr/bin/env bash
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
    
    # Give it permission to run.
    chmod +x "$RELEASE_DIR/linux/uninstaller.sh"

    # ONLY FOR LINUX
    # Create install script (Users can use this to install and set up your app, or they can just use the .AppImage)
    cat <<EOF > "$RELEASE_DIR/linux/install.sh"
#!/usr/bin/env bash

# This command will require sudo permissions, the app will be placed in /opt/$PROJECT_NAME.

# You can uninstall this app at any time by running in your terminal:
# cd /opt/$PROJECT_NAME
# ./uninstaller.sh

# If it doesn't work make sure it has permission by running: chmod +x uninstaller.sh

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
if command -v update-desktop-database >/dev/null; then update-desktop-database "\$HOME/.local/share/applications"; 
fi
echo "Installation complete! Run '$APP_TERMINAL' to start."
echo "To uninstall run: cd /opt/$PROJECT_NAME && sudo chmod +x uninstaller.sh && ./uninstaller.sh"
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


build_windows() {
echo
}


build_macos() {
echo
}

build_ios() {
echo
}

# ============================================================
# MAIN EXECUTION
# ============================================================


# Build options for each platform
case "$PLATFORM" in
	linux) options=$(linux_build_platforms) ;;
	windows) options=$(windows_build_platforms) ;;
	macos) options=$(macos_build_platforms) ;;
	*) echo "Unsupported platform detected"; exit 1 ;;	
esac


# Prompt user to select a platform to build, validating input
while true; do
  # Show options with commas for readability
  options_display=$(echo "$options" | tr ' ' ', ')
  read -p "Select platform to build ($options_display): " USER_PLATFORM

  valid_input=false
  for opt in $options; do
    if [[ "$opt" == "$USER_PLATFORM" ]]; then
      valid_input=true
      break
    fi
  done

  if $valid_input; then
    break
  else
    echo "Invalid input: $USER_PLATFORM. Please try again."
  fi
done

# Dispatch build commands based on selected platform
case "$USER_PLATFORM" in
  android)
    build_android
    ;;
  linux)
    if [[ "$OS_TYPE" == "linux" ]]; then
      build_linux
    else
      echo "Linux builds are only supported on Linux OS."
    fi
    ;;
  windows)
    if [[ "$OS_TYPE" == "windows" ]]; then
      build_windows
    else
      echo "Windows builds are only supported on Windows OS."
    fi
    ;;
  macos)
    if [[ "$OS_TYPE" == "darwin" ]]; then
      build_macos
    else
      echo "macOS builds are only supported on macOS."
    fi
    ;;
  ios)
    if [[ "$OS_TYPE" == "darwin" ]]; then
      build_ios
    else
      echo "iOS builds are only supported on macOS."
    fi
    ;;
  web)
    build_web
    ;;
  all)
    # Build all supported platforms except 'all' itself, respecting OS support
    for platform in $options; do
      [[ "$platform" != "all" ]] || continue
      case "$platform" in
        android) build_android ;;
        linux) [[ "$OS_TYPE" == "linux" ]] && build_linux ;;
        windows) [[ "$OS_TYPE" == "windows" ]] && build_windows ;;
        macos) [[ "$OS_TYPE" == "darwin" ]] && build_macos ;;
        ios) [[ "$OS_TYPE" == "darwin" ]] && build_ios ;;
        web) build_web ;;
      esac
    done
    ;;
  *)
    echo "Unexpected error: invalid platform selected."
    exit 1
    ;;
esac
