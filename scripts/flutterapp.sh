#!/usr/bin/env bash


# This script clones a Flutter template repository, sets up the project folder,
# optionally generates an Android keystore, updates package names, app names,
# and prepares the project for Linux, Windows, Web, Android, iOS, and macOS.


# Works on: Linux, macOS, Windows (Git Bash / WSL)


# Requirements:
#   - git
#   - flutter
#   - Java JDK (for keytool)
#   - Perl (for in-place replacements)


# Usage:
#   ./flutter_setup.sh


# Colors

RED='\033[0;31m' # Error color
GREEN='\033[0;32m' # Success color
YELLOW='\033[1;33m' # Warning color
NC='\033[0m' # No color


# Variables

REPO_URL="https://github.com/euhfs/flutter_template"
DEFAULT_DIR="$HOME/Downloads"

# Check if git, and flutter are installed
command -v git >/dev/null 2>&1 || { echo -e "${RED}[ERROR]:${NC} git is not installed"; exit 1; }
command -v flutter >/dev/null 2>&1 || { echo -e "${RED}[ERROR]:${NC} flutter is not installed"; exit 1; }


# Get started function
get_started() {

while true; do

	# Enter name for the folder
	read -r -p "Enter the name for the main folder (NO SPACES! use -, or _): " MAIN_FOLDER

	# don't allow white spaces
	if [[ "$MAIN_FOLDER" =~ ^[a-zA-Z0-9_-]+$ ]]; then
		break
	else
		echo -e "${RED}[ERROR]:${NC} Folder name contains invalid characters"
	fi
done

# Ask for output location
read -r -p "Enter the location where it should be installed (default: Downloads Folder): " OUTPUT_LOCATION

# If the user pressed Enter without input, set default
if [ -z "$OUTPUT_LOCATION" ]; then
	OUTPUT_LOCATION="$DEFAULT_DIR"
fi

# check if it's a valid path
if [[ ! -d "$OUTPUT_LOCATION" ]]; then
	echo
	echo -e "${RED}[ERROR]:${NC} Output location does not exist: $OUTPUT_LOCATION"
	exit 1
fi

# full path to where repo will be cloned
FINAL_LOCATION="$OUTPUT_LOCATION/$MAIN_FOLDER"

# check if the target directory already exists
if [[ -d "$FINAL_LOCATION" ]]; then
	# make sure it's an github repository and not a random directory
	if git -C "$FINAL_LOCATION" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		# remove the current directory
		echo
		echo -e "${GREEN}[INFO]:${NC} Existing Git repo found. Deleting for fresh clone..."
		rm -rf "$FINAL_LOCATION" || { echo -e "${RED}[ERROR]:${NC} Failed to delete existing Git repository"; exit 1; }
	else
		echo
		echo -e "${RED}[ERROR]:${NC} Directory exists but it is not a git repo, please choose another name"
		exit 1
	fi
fi


# if the directory doesn't already exist, it's safe to clone
git clone "$REPO_URL" "$FINAL_LOCATION" || { echo -e "${RED}[ERROR]:${NC} Failed cloning"; exit 1; }
echo
echo -e "${GREEN}[INFO]:${NC} Repository cloned successfully into $FINAL_LOCATION"


# Go into the root folder and run some flutter commands to make sure everything is clean and up to date

# cd into final location
cd "$FINAL_LOCATION" || exit 1

# run flutter commands
echo
echo -e "${GREEN}[INFO]:${NC} Running flutter commands inside the project..."

flutter pub upgrade || { echo -e "${RED}[ERROR]:${NC} flutter pub upgrade failed"; exit 1; }
flutter clean || { echo -e "${RED}[ERROR]:${NC} flutter clean failed"; exit 1; }
flutter pub get || { echo -e "${RED}[ERROR]:${NC} flutter pub get failed"; exit 1; }

}


# make keystore function
make_keystore() {

# ask for name/dev name for keystore
while true; do
	echo
	read -r -p "Enter your company/dev name to be used in the keystore: " keystore_name
	if [[ "$keystore_name" =~ ^[a-zA-Z0-9_-]{3,30}$ ]]; then
		break
	else
		echo
		echo -e "${RED}[ERROR]:${NC} Name must be 3-30 characters including: letters, digits, underscores, or hyphens only"
	fi
done

# ask for password for keystore
while true; do
	echo
	read -r -s -p "Enter the password to be used for your keystore (Recommended: 64 characters, letters and numbers only, no symbols): " keystore_pass
	if [[ "$keystore_pass" =~ ^[a-zA-Z0-9]{32,128}$ ]]; then
		break
	else
		echo
		echo -e "${RED}[ERROR]:${NC} Password must be at least 32 characters, with no symbols included"
	fi
done

# generate the keystore
keytool -genkeypair \
    -v \
    -keystore "$FINAL_LOCATION/android/app/release.jks" \
    -storepass "$keystore_pass" \
    -keypass "$keystore_pass" \
    -alias "upload_key" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=, OU=, O=, L=, ST=, C="

# generate key.properties as well
echo -e "storeFile=release.jks\nstorePassword=$keystore_pass\nkeyAlias=upload_key\nkeyPassword=$keystore_pass" > "$FINAL_LOCATION/android/key.properties"

echo
echo -e "${GREEN}[INFO]:${NC} keystore and key.properties step finished with no errors!"
}


# function to update proguard file (android)
edit_proguard() {

# ask for package name/id
echo
echo "Now you need to enter the package name (Application ID) for your app. It MUST be UNIQUE!"
echo "Example:  com.yourcompany.appname"
echo
read -r -p "Enter package name: " package_name

# edit the package name inside proguard
replace_in_file "com.example.flutter_template" "$package_name" "$FINAL_LOCATION/android/app/proguard-rules.pro"

echo
echo -e "${GREEN}[INFO]:${NC} Updated proguard-rules.pro with the package name provided."

}

# function to update everything with the correct package name (android)
update_package_name() {

# change package name in build.gradle.kts
replace_in_file "com.example.flutter_template" "$package_name" "$FINAL_LOCATION/android/app/build.gradle.kts"

# change package name in MainActivity.kt before changing folder name based on package name
replace_in_file "com.example.flutter_template" "$package_name" "$FINAL_LOCATION/android/app/src/main/kotlin/com/example/flutter_template/MainActivity.kt"


# Split package name to rename the folders inside kotlin as needed
IFS='.' read -r -a package_parts <<< "$package_name"

old_dir="$FINAL_LOCATION/android/app/src/main/kotlin/com/example/flutter_template"
new_dir="$FINAL_LOCATION/android/app/src/main/kotlin"

for part in "${package_parts[@]}"; do
	new_dir="$new_dir/$part"
done

# make the new directory
mkdir -p "$new_dir"

# move all files from the old dir to new one and delete the old one
if [ -d "$old_dir" ]; then
	mv "$old_dir"/* "$new_dir"/
	rmdir "$old_dir"
else
	echo -e "${RED}[ERROR]:${NC} Old directory does not exist"
	exit 1
fi

echo -e "${GREEN}[INFO]:${NC} Changed all package names inside this project to $package_name"
}

# helper function to edit app names
replace_in_file() {
  local search="$1"
  local replace="$2"
  local file="$3"
  perl -pi -e "s|\Q$search\E|$replace|g" "$file"
}

# function to edit app name
edit_app_name() {

# Ask for app display name
echo
read -r -p "Enter display name for your app: " app_name

# Android
replace_in_file 'flutter_template' "$app_name" "$FINAL_LOCATION/android/app/src/main/AndroidManifest.xml"
echo -e "${GREEN}[INFO]:${NC} Edited android app name to $app_name"

# Windows
replace_in_file 'flutter_template' "$app_name" "$FINAL_LOCATION/windows/runner/main.cpp"
echo -e "${GREEN}[INFO]:${NC} Edited windows app name to $app_name"

# Linux
replace_in_file 'flutter_template' "$app_name" "$FINAL_LOCATION/linux/runner/my_application.cc"
echo -e "${GREEN}[INFO]:${NC} Edited linux app name to $app_name"

# Web
replace_in_file 'flutter_template' "$app_name" "$FINAL_LOCATION/web/index.html"
echo -e "${GREEN}[INFO]:${NC} Edited web app name to $app_name"

# iOS
replace_in_file 'PRODUCT_BUNDLE_IDENTIFIER = com.example.flutterTemplate' "PRODUCT_BUNDLE_IDENTIFIER = $package_name" "$FINAL_LOCATION/ios/Runner.xcodeproj/project.pbxproj"
replace_in_file 'Flutter Template' "$app_name" "$FINAL_LOCATION/ios/Runner/Info.plist"
echo -e "${GREEN}[INFO]:${NC} Edited iOS app name to $app_name"

# macOS
replace_in_file 'PRODUCT_BUNDLE_IDENTIFIER = com.example.flutterTemplate.RunnerTests' "PRODUCT_BUNDLE_IDENTIFIER = $package_name" "$FINAL_LOCATION/macos/Runner.xcodeproj/project.pbxproj"
replace_in_file "PRODUCT_NAME = $(TARGET_NAME);" "PRODUCT_NAME = \"$app_name\";" "$FINAL_LOCATION/macos/Runner.xcodeproj/project.pbxproj"
echo -e "${GREEN}[INFO]:${NC} Edited macOS app name to $app_name"

}

edit_pubspec() {
# change name to folder name as flutter does by default
replace_in_file 'flutter_template' "$MAIN_FOLDER" "$FINAL_LOCATION/pubspec.yaml"
echo
echo -e "${GREEN}[INFO]:${NC} Changed pubspec.yaml 'name:' as your project's folder name"

}


edit_cmake() {

# Edit binary name
replace_in_file 'flutter_template' "$MAIN_FOLDER" "$FINAL_LOCATION/linux/CMakeLists.txt"

# Edit app id (package_name)
replace_in_file 'com.example.flutter_template' "$package_name" "$FINAL_LOCATION/linux/CMakeLists.txt"

}


# run get started step
get_started


# Generate keystore and key.properties and move inside final location in proper spaces
echo
echo -e "${GREEN}[INFO]:${NC} Downloaded flutter template into $FINAL_LOCATION"
echo "If you plan to release the app on Android, a keystore is required. If not, you may skip this step."
echo -e "${YELLOW}[WARNING]:${NC} Skipping this avoids android setup entirely"

# ask to skip this step or not
echo
read -r -p "Do you want to set up the app for Android? (y/n): " choice


# skip or not based on input

case $choice in
	[nN]* ) echo -e "${GREEN}[INFO]:${NC} Skipping step..." ;;
	[yY]* ) echo -e "${GREEN}[INFO]:${NC} Entering keystore setup..."
		make_keystore
		edit_proguard
		update_package_name
	      	;;
	*) echo "Please enter (y/n):" ;;
esac


# run edit app name to change app name on available platforms
edit_app_name

# run edit pubspec to change 'name:' to folder name
edit_pubspec

# run edit cmake to change some stuff for linux
edit_cmake

# Finish messages
echo
echo -e "${GREEN}[DONE]:${NC} Project setup complete!"
echo "Location: $FINAL_LOCATION"
echo "App Name: $app_name"
[[ -n "$package_name" ]] && echo "Package Name: $package_name"
