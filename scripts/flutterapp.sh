#!/bin/bash

# get started function

get_started() {

while true; do

	# Enter name for the folder
	read -p "Enter the name for the main folder (NO SPACES! use -, or _): " MAIN_FOLDER

	# don't allow white spaces
	if [[ "$MAIN_FOLDER" =~ ^[a-zA-Z0-9_-]+$ ]]; then
		break
	else
		echo "[ERROR]: Folder name contains invalid characters"
	fi
done

# Ask for output location
read -p "Enter the location where it should be installed (default: Downloads Folder): " OUTPUT_LOCATION

# check if it's a valid path
if [[ ! -d "$OUTPUT_LOCATION" ]]; then
	echo
	echo "[ERROR]: Output location does not exist"
	exit 1
fi

# If the user pressed Enter without input, set default
if [ -z "$OUTPUT_LOCATION" ]; then
    OUTPUT_LOCATION="$HOME/Downloads"
fi


# Clone template repo
git clone "https://github.com/euhfs/flutter_template" "$OUTPUT_LOCATION/$MAIN_FOLDER"

# abort if cloning failed
if [[ $? -ne 0 ]]; then
	echo
	echo "[ERROR]: Failed to clone repo"
	exit 1
fi

# Go into the root folder and run some flutter commands to make sure everything is clean and up to date

# get final location
FINAL_LOCATION="$OUTPUT_LOCATION/$MAIN_FOLDER"

# cd into final location
cd "$FINAL_LOCATION" || exit 1

# run flutter commands
flutter pub upgrade || { echo "[ERROR]: flutter pub upgrade failed"; exit 1; }
flutter clean || { echo "[ERROR]: flutter clean failed"; exit 1; }
flutter pub get || { echo "[ERROR]: flutter pub get failed"; exit 1; }

}


# make keystore function
make_keystore() {

# ask for name/dev name for keystore
echo
read -p "Enter your company/dev name to be used in the keystore: " keystore_name

# ask for password for keystore
read -s -p "Enter the password to be used for your keystore (DON'T LOSE THIS AND MAKE IT (64 characters recommended)  WITH NO SYMBOLS!): " keystore_pass

if [[ ! "$keystore_pass" =~ ^[a-zA-Z0-9]{32}$ ]]; then
	echo
	echo "[ERROR]: Password must be at least 32 characters, with no symbols included"
	exit 1
fi

# generate the keystore
keytool -genkeypair \
    -v \
    -keystore "$FINAL_LOCATION/android/app/release.jks" \
    -storepass "$keystore_pass" \
    -keypass "$keystore_pass" \
    -alias "$keystore_name" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000\
    -dname "CN=, OU=, O=, L=, ST=, C="

# generate key.properties aswell
echo -e "storeFile=release.jks\nstorePassword=$keystore_pass\nkeyAlias=upload_key\nkeyPassword=$keystore_pass" > "$FINAL_LOCATION/android/key.properties"

echo
echo "[INFO]: keystore and key.properties step finished with no errors!"
}


# function to update proguard file (android)
edit_proguard() {

# ask for package name/id
echo
echo "Now you need to enter the package name (Application ID) for your app. It MUST be UNIQUE!"
echo "Example:  com.yourcompany.appname"
echo
read -p "Enter package name: " package_name

# edit the package name inside proguard
sed -i "s|com.example.flutter_template|$package_name|g" "$FINAL_LOCATION/android/app/proguard-rules.pro"

echo
echo "[INFO]: Updated proguard-rules.pro with the package name provided."

}

# function to update everything with the correct package name (android)
update_package_name() {

# change package name in build.gradle.kts
sed -i "s|com.example.flutter_template|$package_name|g" "$FINAL_LOCATION/android/app/build.gradle.kts"

# change package name in MainActivity.kt before changing folder name based on package name
sed -i "s|com.example.flutter_template|$package_name|g" "$FINAL_LOCATION/android/app/src/main/kotlin/com/example/flutter_template/MainActivity.kt"

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
	echo "[ERROR]: Old directory does not exist"
	exit 1
fi

echo "[INFO]: Changed all package names inside this project to $package_name"
}

# function to edit app name
edit_app_name() {

# Ask for app display name
echo
read -p "Enter display name for your app: " app_name

# edit app name on android
sed -i "s|flutter_template|$app_name|g" "$FINAL_LOCATION/android/app/src/main/AndroidManifest.xml"
echo "[INFO]: Edited android app name to $app_name"

# edit app name on windows
sed -i "s|flutter_template|$app_name|g" "$FINAL_LOCATION/windows/runner/main.cpp"
echo "[INFO]: Edited windows app name to $app_name"

# edit app name on linux
sed -i "s|flutter_template|$app_name|g" "$FINAL_LOCATION/linux/runner/my_application.cc"
echo "[INFO]: Edited linux app name to $app_name"

# edit app name on web
sed -i "s|flutter_template|$app_name|g" "$FINAL_LOCATION/web/index.html"
echo "[INFO]: Edited web app name to $app_name"

}

edit_pubspec() {

# change name to folder name as flutte does by default
sed -i "s|flutter_template|$MAIN_FOLDER|g" "$FINAL_LOCATION/pubspec.yaml"
echo
echo "[INFO]: Changed pubspec.yaml 'name:' as your project's folder name"

}



# run get started step
get_started


# Generate keystore and key.properties and move inside final location in proper spaces
echo
echo "Downloaded flutter template into $FINAL_LOCATION, now you need to skip or continue with the following step:"
echo "If you wish to use the app for android you need a keystore, if you don't skip this step."
echo "[Important]: Skipping this, avoids android setup entirely"

# ask to skip this step or not
echo
read -p "Do you want to skip this step? (y/n): " choice


# skip or not based on input

case $choice in
	[yY]* ) echo "Skipping step..." ;;
	[nN]* ) echo "Entering keystore setup..."
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
