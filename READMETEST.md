1. What this project is and what it does.
2. Table of contents
3. Step by step on how to download and configure manually + info about scripts
4. Step by step on how to download and configure automatically + info about scripts + How to use on windows linux and so on
5. Folder structure
6. App icon
7. Splash screen


# Flutter Project Template

**This Project is a flutter template that has all the basic things done for you. All you need to do is download it and get straight to producing apps faster than ever. All sections will have a step by step guide on how to configure everything.**

## Table of contents

- [**Automated setup**]()
- [**Manual setup**]()
- [**Project structure**]()
- [**App icon**]()
- [**Splash screen**]()
- []()
- []()
- []()


### Before getting started I recommend you to install the next things based on your OS:

1. Windows
    - Install git from: https://git-scm.com/install/windows and follow instructions (I recommend to leave all values to default). (Make sure after installation that you have "Git Bash")
    - Install Inno Setup from: https://jrsoftware.org/isdl.php and follow instructions.

2. Linux
    - Install appimagetool from: https://github.com/AppImage/appimagetool/releases/tag/continuous and get `appimagetool-x86_64.AppImage`

3. macOS
    - Install Xcode from: https://apps.apple.com/us/app/xcode/id497799835?mt=12    

And obviously make sure you have flutter installed. If you want to set up the project for android make sure you have `keytool` installed on your system. All you need to do is install: https://www.oracle.com/java/technologies/downloads/ otherwise android setup won't work.


## Automated Setup

1. Windows <br>
    **(To paste commands in the terminal use right click)**
    - Open Git Bash and navigate to your preferred directory e.g. `cd ~/Documents` . This navigates to your Documents directory.
    - Now you have to install the setup script and run it. To do that run in the terminal: 
    ```bash
    winpty curl -o flutterapp.sh https://raw.githubusercontent.com/euhfs/flutter_template/refs/heads/main/scripts/flutter_setup.sh && ./flutter_setup.sh
    ```
    - Now follow scripts instructions:
        * `Enter the name for the main folder:` <br> The name you would enter when using flutter to generate an project. For example: **password_generator**

        * `Enter the location where it should be installed:` <br> Leave empty to use downloads folder or use your projects folder. For example: **C:\Users\YOURUSER\Documents\MyProjects**

        * `Enter the display name for your app:` <br> The display name is what users will see for your app. For example: **Password Generator**

        * `Enter package name:` <br> A unique identifier for your app, usually in reverse domain format. For example: **com.euhfs.passwordgenerator**

        * `Do you want to set up the keystore for Android? (y/n):` <br> Here you can skip the android keystore setup. It is **very important** if your project is for **android** since it will be used for your release apk and will give errors if you don't have it. (Can still be done **manually** later. Check manual setup on how to set up the keystore)

        * If you chose "y" in the previous step it will ask for **company/dev name** and **password** to be used in the keystore. The company/dev name is not that important and can be anything **BUT** the password is really important, make sure not to lose it.

        

        <!-- * `Do you want to set up the app for Android? (y/n):` enter "y" or "n" if you want or don't want to set up for android. -->

        <!-- * If "y": `Enter your company/dev name to be used in the keystore:` for example: `euhfs` -->

        <!-- * `Enter the password to be used for your keystore:` just enter an password (make sure not to lose it) -->

        
