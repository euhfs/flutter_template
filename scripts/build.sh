#!/usr/bin/env bash


# ============================================================
# Flutter Multi-Platform Build Script
# ============================================================


# Supported OS:
#   - Linux
#   - Windows (via MinGW which is Git Bash App)
#   - macOS (untested, experimental)


# Variables that NEED to be modified (Section "PATHS + DIRECTORIES + VARIABLES"):
# 1. APP_VERSION="1.0.0+1"
#    - The version of your app (used in Flutter and some shortcuts).
#
# 2. APP_NAME="Flutter Template"
#    - The display name of your app.
#    - Used for shortcuts and desktop installers.
#    - Note: For Android and iOS, you must also modify the appropriate project files.
#
# 3. APP_DESCRIPTION="A Flutter template..."
#    - The description of your app.
#    - Appears in shortcuts and installers.
#
# 4. APP_TERMINAL="flutter-template"
#    - The command you can use in the terminal to run your app (Linux/macOS only).
#
# FOR WINDOWS:
# 5. APP_PUBLISHER="euhfs"
#    - Change this to your publisher name.
#    - Used for metadata in installers and shortcuts.
#
# 6. APP_URL="https://github.com/euhfs/flutter_template"
#    - URL for your app or repository.
#    - Optional, but recommended for reference in shortcuts or about dialogs.
#
# 7. APP_ID="{{5193F39C-8C38-41CF-93C2-07F401FB0530}}"
#    - The unique identifier for your app.
#    - Must be changed to something other than what is set by default.
#    - Needs to be the same APP_ID for the same app, but different for different apps.
#    - To generate a new APP_ID:
#       * Open inno setup
#	* Go to "tools" tab or press "CTRL + SHIFT + G"
#	* Replace the APP_ID with what was generated
#	* NOTE: only replace the numbers and make sure the final string has {{ID}} with 2 brackets at the start and end

# Instructions:
#   1. Make sure the script has execute permissions:
#        chmod +x scripts/build.sh
#   2. Run the script:
#        ./scripts/build.sh
#   3. Download necessary tools:
#        Linux: AppImageTool
#        Windows: Inno Setup
#        macOS: Xcode

# To download appimagetool: https://github.com/AppImage/appimagetool/releases/tag/continuous and get appimagetool-x86_64.AppImage  
# To download Inno Setup: https://jrsoftware.org/isdl.php#stable
# To download Xcode: https://apps.apple.com/us/app/xcode/id497799835?mt=12

# What this script does:
# - Builds your Flutter project for selected platforms.
# - Creates an output folder in Documents/flutter/outputs/$PROJECT_NAME.
# - Creates a release folder with ready-to-share builds:
#     - Linux: AppImage (can be zipped & installed via installer script)
#     - Android: APKs (split per ABI + universal)
#     - Windows: Installer via Inno Setup
#     - Web: Fully built static files
#     - macOS/iOS: .app bundles (untested)


# ============================================================
# PATHS + DIRECTORIES + VARIABLES
# ============================================================

PROJECT_NAME=$(basename "$PWD") # I do not recommend changing this, leaving it as the root's directory name is the best idea to make sure everything works right and you have no errors.
ICON_PATH="./assets/app-icon/app_icon.png" # Change to your icon path as needed. (used for the icon of the app shortcut on linux/macOS)

APP_VERSION="1.0.0+1" # This will be the displayed version of your app "+1" is the build number.
APP_NAME="Flutter Template" # This will be the name of your linux/windows/macOS.
APP_DESCRIPTION="A flutter template useful for building apps easier." # This will be the description of your linux/macOS.
APP_TERMINAL="flutter-template" # This will be the command that you can use to run your app from terminal on linux/macOS.


# Variables for linux (LEAVE AS IT IS IF YOU DON'T BUILD FOR LINUX)
APPIMAGETOOL="$HOME/Documents/flutter/appimagetool-x86_64.AppImage" # Change to your appimage tool path as needed.

# Variables for windows
INNO_SETUP="C:\Program Files (x86)\Inno Setup 6\ISCC.exe" # Change to your inno setup executable path as needed.

APP_PUBLISHER="euhfs" # Change this to your publisher name
APP_URL="https://github.com/euhfs/flutter_template" # Website of your app or github repo (leave empty if you don't have one)
APP_ID="{{5193F39C-8C38-41CF-93C2-07F401FB0530}}" # Unique identifier for your app (keep as a GUID)
# GUID = It’s meant to be unique across all apps, so no two apps should share the same one.

# Modify these with the location where you wish the directories to be located.
OUTPUT_DIR="$HOME/Documents/flutter/outputs/$PROJECT_NAME" # This is where all the files/folders will go when you build your project.
RELEASE_DIR="$HOME/Documents/flutter/release/$PROJECT_NAME" # This is where all the final outputs will be located when everything is finished, these are the files/folders you can use to share your app.
LINUX_BUILD_DIR="$HOME/Documents/flutter/build/$PROJECT_NAME" # This will be where your linux app will make the AppDir folder (used to prepare the final .AppImage output).


# Don't need to modify these since they are project wise.
BUILD_DIR="$PWD/build"
APKBUILD_DIR="$BUILD_DIR/app/outputs/flutter-apk"
AABBUILD_DIR="$BUILD_DIR/app/outputs/bundle/release"
LINUXBUILD_DIR="$BUILD_DIR/linux/x64/release/bundle"
WEBBUILD_DIR="$BUILD_DIR/web"
MACOSBUILD_DIR="$BUILD_DIR/macos/Build/Products/Release"
IOSBUILD_DIR="$BUILD_DIR/ios/iphoneos"
WINDOWSBUILD_DIR="$BUILD_DIR/windows/x64/runner/Release"

# LINUX_BUILD_DIR and LINUXBUILD_DIR have confusing names but I couldn't think of any better name for it. LINUXBUILD_DIR is where the files from running flutter build linux will go and LINUX_BUILD_DIR is where the output AppDir directory will be located, I only recommend to change LINUX_BUILD_DIR as the other 2 above it (OUTPUT_DIR, RELEASE_DIR). SAME FOR WINDOWS

# Create required directories
mkdir -p "$OUTPUT_DIR/android" "$OUTPUT_DIR/linux" "$OUTPUT_DIR/web" "$OUTPUT_DIR/macos" "$OUTPUT_DIR/ios" "$OUTPUT_DIR/windows"
mkdir -p "$RELEASE_DIR/android" "$RELEASE_DIR/linux" "$RELEASE_DIR/web" "$RELEASE_DIR/macos" "$RELEASE_DIR/ios" "$RELEASE_DIR/windows"

# Change version inside pubspec
sed -i'' "s/^version: .*/version: $APP_VERSION/" pubspec.yaml


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
BUILD_AAB="flutter build aab --release"
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
    $BUILD_AAB

    copy_file "$APKBUILD_DIR/app-armeabi-v7a-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_armeabi-v7a.apk"
    copy_file "$APKBUILD_DIR/app-arm64-v8a-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_arm64.apk"
    copy_file "$APKBUILD_DIR/app-x86_64-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_x86-64.apk"
    copy_file "$APKBUILD_DIR/app-release.apk" "$OUTPUT_DIR/android/${PROJECT_NAME}_universal.apk"
    copy_file "$AABBUILD_DIR/app-release.aab" "$OUTPUT_DIR/android/${PROJECT_NAME}.aab"

    mkdir -p "$RELEASE_DIR/android/"
    cp -r "$OUTPUT_DIR/android/"* "$RELEASE_DIR/android/"
    echo "Android build completed."
}

build_linux() {
    $BUILD_LINUX

    # Prepare directories
    mkdir -p "$LINUX_BUILD_DIR/AppDir"
    cp -r "$LINUXBUILD_DIR/"* "$LINUX_BUILD_DIR/AppDir/"

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

    # Check appimagetool
    if [ ! -x "$APPIMAGETOOL" ]; then
    	echo "AppImage tool not found or not executable at $APPIMAGETOOL"
    	exit 1
    fi

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
    mv "$OUTPUT_DIR/windows/$PROJECT_NAME.exe" "$OUTPUT_DIR/windows/$PROJECT_NAME.exe"

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
OutputBaseFilename=${PROJECT_NAME}
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "${WIN_OUTPUT_DIR}\\windows\\${PROJECT_NAME}.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${WIN_OUTPUT_DIR}\\windows\\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
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
    echo "This is not tested, and will only build and move the outputs to the outputs folder."
    $BUILD_MACOS

    # Ensure directories exist
    mkdir -p "$OUTPUT_DIR/macos"
    mkdir -p "$RELEASE_DIR/macos"

    # Copy .app bundle
    if [ -d "$MACOSBUILD_DIR/$APP_NAME.app" ]; then
        cp -r "$MACOSBUILD_DIR/$APP_NAME.app" "$OUTPUT_DIR/macos/"
        cp -r "$MACOSBUILD_DIR/$APP_NAME.app" "$RELEASE_DIR/macos/"
        echo "Copied $APP_NAME.app to output and release directories."
    else
        echo "macOS build folder not found at $MACOSBUILD_DIR. Make sure 'flutter build macos' completed successfully."
    fi

    # Create a zip for distribution
    cd "$RELEASE_DIR/macos" || exit 1
    zip -r "$PROJECT_NAME-macos.zip" "$APP_NAME.app"
    cd - >/dev/null || exit

    # ------------------------------
    # Create installer script
    # ------------------------------
    cat <<EOF > "$RELEASE_DIR/macos/install.sh"
$(sed 's/^/    /' <<'SCRIPT_EOF'
#!/usr/bin/env bash

APP_NAME="$APP_NAME"
PROJECT_NAME="$PROJECT_NAME"
APP_DESCRIPTION="$APP_DESCRIPTION"
APP_TERMINAL="$APP_TERMINAL"

APP_DIR="$HOME/Applications/$APP_NAME.app"
DESKTOP_FILE="$HOME/.local/share/applications/$PROJECT_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$PROJECT_NAME.png"
SYMLINK="$HOME/.local/bin/$APP_TERMINAL"
SOURCE_APP="$RELEASE_DIR/macos/$APP_NAME.app"
ICON_SOURCE="$ICON_PATH"

echo "Installing $APP_NAME..."

mkdir -p "$(dirname "$DESKTOP_FILE")"
mkdir -p "$(dirname "$ICON_FILE")"
mkdir -p "$(dirname "$SYMLINK")"

if [ -d "$SOURCE_APP" ]; then
  cp -R "$SOURCE_APP" "$APP_DIR"
else
  echo "App bundle not found at $SOURCE_APP"
  exit 1
fi

if [ -f "$ICON_SOURCE" ]; then
  cp "$ICON_SOURCE" "$ICON_FILE"
else
  echo "Icon not found, skipping."
fi

cat > "$DESKTOP_FILE" <<DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=open "$APP_DIR"
Icon=$ICON_FILE
Comment=$APP_DESCRIPTION
Categories=Utility;
Terminal=false
DESKTOP_EOF

ln -sf "$APP_DIR/Contents/MacOS/$PROJECT_NAME" "$SYMLINK"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications"
fi

echo "Installation complete!"
echo "Run '$APP_TERMINAL' to start your app."
echo "To uninstall: cd $HOME && ./Documents/flutter/release/$PROJECT_NAME/macos/uninstaller.sh"
SCRIPT_EOF
)
EOF
    chmod +x "$RELEASE_DIR/macos/install.sh"

    # ------------------------------
    # Create uninstaller script
    # ------------------------------
    cat <<EOF > "$RELEASE_DIR/macos/uninstaller.sh"
#!/usr/bin/env bash

APP_NAME="$APP_NAME"
PROJECT_NAME="$PROJECT_NAME"
APP_DIR="$HOME/Applications/$APP_NAME.app"
DESKTOP_FILE="$HOME/.local/share/applications/$PROJECT_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$PROJECT_NAME.png"
SYMLINK="$HOME/.local/bin/$APP_TERMINAL"

echo "Uninstalling $APP_NAME..."

[ -d "\$APP_DIR" ] && rm -rf "\$APP_DIR"
[ -f "\$DESKTOP_FILE" ] && rm "\$DESKTOP_FILE"
[ -f "\$ICON_FILE" ] && rm "\$ICON_FILE"
[ -L "\$SYMLINK" ] && rm "\$SYMLINK"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "\$HOME/.local/share/applications"
fi

echo "\$APP_NAME uninstalled successfully."
EOF
    chmod +x "$RELEASE_DIR/macos/uninstaller.sh"

    echo "macOS build completed successfully."
}

build_ios() {
    echo "This is not tested, and will only build and move the outputs to the outputs folder."
    $BUILD_IOS

    # Ensure directories exist
    mkdir -p "$OUTPUT_DIR/ios"
    mkdir -p "$RELEASE_DIR/ios"

    IOS_APP_PATH="$IOSBUILD_DIR/Runner.app"
    IOS_IPA_PATH="$IOSBUILD_DIR/Runner.ipa"

    # Copy .app bundle (device build)
    if [ -d "$IOS_APP_PATH" ]; then
        cp -r "$IOS_APP_PATH" "$OUTPUT_DIR/ios/"
        cp -r "$IOS_APP_PATH" "$RELEASE_DIR/ios/"
        echo "Copied Runner.app to output and release directories."
    else
        echo "No Runner.app found in $IOSBUILD_DIR (you may need a physical device connected)."
    fi

    # Copy .ipa file (if exists)
    if [ -f "$IOS_IPA_PATH" ]; then
        cp "$IOS_IPA_PATH" "$OUTPUT_DIR/ios/"
        cp "$IOS_IPA_PATH" "$RELEASE_DIR/ios/"
        echo "Copied Runner.ipa to output and release directories."
    else
        echo "No Runner.ipa found — you can create one via 'flutter build ipa' if needed."
    fi

    # Create a zip archive for easy distribution
    cd "$RELEASE_DIR/ios" || exit 1
    if [ -d "Runner.app" ]; then
        zip -r "$PROJECT_NAME-ios-app.zip" "Runner.app"
    fi
    if [ -f "Runner.ipa" ]; then
        zip -r "$PROJECT_NAME-ios-ipa.zip" "Runner.ipa"
    fi
    cd - >/dev/null || exit

    echo "iOS build completed successfully."
    echo "Output: $RELEASE_DIR/ios"
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
  options_display="${options// /, }"
  read -r -p "Select platform to build ($options_display): " USER_PLATFORM

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
