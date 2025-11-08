#!/usr/bin/env bash

# This is only supported and tested on linux and windows (via MinGW) only, it supports macos but it has not been tested since I don't have a mac.
# If anyone has a mac and wants to test this please feel free and contact me.

# How to run:
## Run in terminal: scripts/build.sh
## If it doesn't work make sure it has the right permissions to run: chmod +x scripts/build.sh
## First make sure you have the folder flutter inside Documents folder or edit the path, and add appimagetool-x86_64.AppImage install it from: https://github.com/AppImage/appimagetool/releases
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
APP_VERSION="1.0.0" # TODO change

# Variables for linux (LEAVE AS IT IS IF YOU DON'T BUILD FOR LINUX)
APPIMAGETOOL="$HOME/Documents/flutter/appimagetool-x86_64.AppImage" # Change to your appimage tool path as needed.
APP_NAME="Flutter Template" # This will be the name of your linux app.
APP_DESCRIPTION="A flutter template useful for building apps easier." # This will be the description of your linux app.
APP_TERMINAL="flutter-template" # This will be the command that you can use to run your app from terminal.
ICON_PATH="./assets/app-icon/app_icon.png" # Change to your icon path as needed. (used for app shortcut logo)

# Variables for windows
INNO_SETUP="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
APP_PUBLISHER="euhfs"
APP_URL="https://github.com/euhfs/flutter_template"
APP_ID="{{5193F39C-8C38-41CF-93C2-07F401FB0530}}"


# Modify these with the location where you wish the directories to be located.
OUTPUT_DIR="$HOME/Documents/flutter/outputs/$PROJECT_NAME" # This is where all the files/folders will go when you build your project.
RELEASE_DIR="$HOME/Documents/flutter/release/$PROJECT_NAME" # This is where all the final outputs will be located when everything is finished, these are the files/folders you can use to share your app.
LINUX_BUILD_DIR="$HOME/Documents/flutter/build/$PROJECT_NAME" # This will be where your linux app will make the AppDir folder (used to prepare the final .AppImage output).


# Don't need to modify these since they are project wise.
BUILD_DIR="$PWD/build"
APKBUILD_DIR="$BUILD_DIR/app/outputs/flutter-apk"
LINUXBUILD_DIR="$BUILD_DIR/linux/x64/release/bundle"
WEBBUILD_DIR="$BUILD_DIR/web"
MACOSBUILD_DIR="$BUILD_DIR/macos/Build/Products/Release"
IOSBUILD_DIR="$BUILD_DIR/ios/iphoneos"
WINDOWSBUILD_DIR="$BUILD_DIR/windows/x64/runner/Release"

# LINUX_BUILD_DIR and LINUXBUILD_DIR have confusing names but I couldn't think of any better name for it. LINUXBUILD_DIR is where the files from running flutter build linux will go and LINUX_BUILD_DIR is where the output AppDir directory will be located, I only recommend to change LINUX_BUILD_DIR as the other 2 above it (OUTPUT_DIR, RELEASE_DIR). SAME FOR WINDOWS

# Create required directories
mkdir -p "$OUTPUT_DIR/android" "$OUTPUT_DIR/linux" "$OUTPUT_DIR/web" "$OUTPUT_DIR/macos" "$OUTPUT_DIR/ios" "$OUTPUT_DIR/windows"
mkdir -p "$RELEASE_DIR/android" "$RELEASE_DIR/linux" "$RELEASE_DIR/web" "$RELEASE_DIR/macos" "$RELEASE_DIR/ios" "$RELEASE_DIR/windows"


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
    mingw*)
        PLATFORM="windows"
        echo "Running on Windows (via MinGW)"
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
BUILD_WINDOWS="flutter build windows --release"
BUILD_MACOS="flutter build macos --release"
BUILD_IOS="flutter build ios --release"


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
    $BUILD_LINUX

    # Prepare directories
    cp -r "$LINUXBUILD_DIR" "$OUTPUT_DIR/linux/"
    mkdir -p "$LINUX_BUILD_DIR/AppDir"
    cp -r "$OUTPUT_DIR/linux/bundle/"* "$LINUX_BUILD_DIR/AppDir/" 2>/dev/null || true

    # Copy icon
    if [ ! -f "$ICON_PATH" ]; then
        echo "Error: Icon file not found at $ICON_PATH"
        exit 1
    fi
    cp "$ICON_PATH" "$LINUX_BUILD_DIR/AppDir/.DirIcon.png"

    # Make binary executable
    chmod +x "$LINUX_BUILD_DIR/AppDir/$PROJECT_NAME" 2>/dev/null || true

    # Create AppRun file
    cat <<EOF > "$LINUX_BUILD_DIR/AppDir/AppRun"
#!/usr/bin/env bash
HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\$HERE/$PROJECT_NAME" "\$@"
EOF
    chmod +x "$LINUX_BUILD_DIR/AppDir/AppRun"

    # Create desktop entry
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

    # Make release dir
    mkdir -p "$RELEASE_DIR/linux/"

    # Build AppImage
    ARCH="x86_64" "$APPIMAGETOOL" "$LINUX_BUILD_DIR/AppDir" "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"
    chmod +x "$RELEASE_DIR/linux/$PROJECT_NAME.AppImage"
    cp "$LINUX_BUILD_DIR/AppDir/.DirIcon.png" "$RELEASE_DIR/linux/$PROJECT_NAME.png"

    # ------------------------------
    # Create uninstaller script
    # ------------------------------
    cat <<EOF > "$RELEASE_DIR/linux/uninstaller.sh"
#!/usr/bin/env bash

APP_NAME="$APP_NAME"
PROJECT_NAME="$PROJECT_NAME"

APP_DIR="\$HOME/.local/share/\$PROJECT_NAME"
DESKTOP_FILE="\$HOME/.local/share/applications/\$PROJECT_NAME.desktop"
ICON_FILE="\$HOME/.local/share/icons/\$PROJECT_NAME.png"
SYMLINK="\$HOME/.local/bin/\$PROJECT_NAME"

echo "Uninstalling \$APP_NAME..."
[ -d "\$APP_DIR" ] && rm -rf "\$APP_DIR"
[ -f "\$DESKTOP_FILE" ] && rm "\$DESKTOP_FILE"
[ -f "\$ICON_FILE" ] && rm "\$ICON_FILE"
[ -L "\$SYMLINK" ] && rm "\$SYMLINK"

if command -v update-desktop-database >/dev/null; then
  update-desktop-database "\$HOME/.local/share/applications"
fi

echo "\$APP_NAME uninstalled successfully."
EOF
    chmod +x "$RELEASE_DIR/linux/uninstaller.sh"

    # ------------------------------
    # Create installer script
    # ------------------------------
    cat <<EOF > "$RELEASE_DIR/linux/install.sh"
#!/usr/bin/env bash

APP_NAME="$APP_NAME"
PROJECT_NAME="$PROJECT_NAME"
APP_DESCRIPTION="$APP_DESCRIPTION"
APP_TERMINAL="$APP_TERMINAL"
ICON_PATH="$RELEASE_DIR/linux/$PROJECT_NAME.png"

APP_DIR="\$HOME/.local/share/\$PROJECT_NAME"
APPIMAGE_NAME="\$PROJECT_NAME.AppImage"
DESKTOP_FILE="\$HOME/.local/share/applications/\$PROJECT_NAME.desktop"
ICON_FILE="\$HOME/.local/share/icons/\$PROJECT_NAME.png"
SYMLINK="\$HOME/.local/bin/\$APP_TERMINAL"

mkdir -p "\$APP_DIR"
cp "\$APPIMAGE_NAME" "\$APP_DIR/"
chmod +x "\$APP_DIR/\$APPIMAGE_NAME"

cp "uninstaller.sh" "\$APP_DIR/"
chmod +x "\$APP_DIR/uninstaller.sh"

mkdir -p "\$(dirname "\$DESKTOP_FILE")"
cat > "\$DESKTOP_FILE" <<DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=\$APP_NAME
Exec="\$APP_DIR/\$APPIMAGE_NAME"
Icon=\$ICON_FILE
Comment=\$APP_DESCRIPTION
Categories=Utility;
Terminal=false
DESKTOP_EOF

mkdir -p "\$(dirname "\$ICON_FILE")"
cp "\$ICON_PATH" "\$ICON_FILE"

mkdir -p "\$(dirname "\$SYMLINK")"
ln -sf "\$APP_DIR/\$APPIMAGE_NAME" "\$SYMLINK"

if command -v update-desktop-database >/dev/null; then
  update-desktop-database "\$HOME/.local/share/applications"
fi

echo "Installation complete!"
echo "Run '\$APP_TERMINAL' to start your app."
echo "To uninstall: cd \$HOME/.local/share/\$PROJECT_NAME && ./uninstaller.sh"
EOF
    chmod +x "$RELEASE_DIR/linux/install.sh"

    echo "Linux build completed successfully."
}

build_web() {
    $BUILD_WEB

    cp -r "$WEBBUILD_DIR/"* "$OUTPUT_DIR/web/" 2>/dev/null || true

    mkdir -p "$RELEASE_DIR/web/"
    cp -r "$OUTPUT_DIR/web/"* "$RELEASE_DIR/web/"

    echo "Web build completed."
}


build_windows() {
    $BUILD_WINDOWS

    cp -r "$WINDOWSBUILD_DIR/"* "$OUTPUT_DIR/windows/" 2>/dev/null || true
    mv "$OUTPUT_DIR/windows/flutter_template.exe" "$OUTPUT_DIR/windows/$PROJECT_NAME.exe"

    # Create temporary .iss file
    TMP_ISS=$(mktemp /tmp/generated-iss-XXXXXX.iss) || exit 1

    # Convert paths to make them work
    WIN_RELEASE_DIR=$(cygpath -w "$RELEASE_DIR")
    WIN_OUTPUT_DIR=$(cygpath -w "$OUTPUT_DIR")

    cat > "$TMP_ISS" <<EOF
[Setup]
AppId=${APP_ID}
AppName=${APP_NAME}
AppVersion=${APP_VERSION}
AppPublisher=${APP_PUBLISHER}
AppPublisherURL=${APP_URL}
AppSupportURL=${APP_URL}
AppUpdatesURL=${APP_URL}
DefaultDirName={autopf}\\${PROJECT_NAME}
UninstallDisplayIcon={app}\\${PROJECT_NAME}.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
OutputDir=${WIN_RELEASE_DIR}\\windows
OutputBaseFilename=${APP_NAME}
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "${WIN_OUTPUT_DIR}\\windows\\${PROJECT_NAME}.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${WIN_OUTPUT_DIR}\\windows\\${PROJECT_NAME}.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${WIN_OUTPUT_DIR}\\windows\\data\\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\${APP_NAME}"; Filename: "{app}\\${PROJECT_NAME}.exe"
Name: "{autodesktop}\\${APP_NAME}"; Filename: "{app}\\${PROJECT_NAME}.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\\${PROJECT_NAME}.exe"; Description: "Launch ${APP_NAME}"; Flags: nowait postinstall skipifsilent
EOF

    "$INNO_SETUP" "$TMP_ISS"

    rm "$TMP_ISS"   
}


build_macos() {
    echo "This is not tested, and will only build and move the ouputs to the outputs folder."
    $BUILD_MACOS
}

build_ios() {
    echo "This is not tested, and will only build and move the ouputs to the outputs folder."
    $BUILD_IOS
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
  options_display=$(echo "$options" | sed 's/ /, /g')
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
    if [[ "$PLATFORM" == "linux" ]]; then
      build_linux
    else
      echo "Linux builds are only supported on Linux OS."
    fi
    ;;
  windows)
    if [[ "$PLATFORM" == "windows" ]]; then
      build_windows
    else
      echo "Windows builds are only supported on Windows OS."
    fi
    ;;
  macos)
    if [[ "$PLATFORM" == "macos" ]]; then
      build_macos
    else
      echo "macOS builds are only supported on macOS."
    fi
    ;;
  ios)
    if [[ "$PLATFORM" == "macos" ]]; then
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
        linux) [[ "$PLATFORM" == "linux" ]] && build_linux ;;
        windows) [[ "$PLATFORM" == "windows" ]] && build_windows ;;
        macos) [[ "$PLATFORM" == "macos" ]] && build_macos ;;
        ios) [[ "$PLATFORM" == "macos" ]] && build_ios ;;
        web) build_web ;;
      esac
    done
    ;;
  *)
    echo "Unexpected error: invalid platform selected."
    exit 1
    ;;
esac
