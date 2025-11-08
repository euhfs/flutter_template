# Straight forward just run scripts/build_icon_splash.sh

flutter clean && flutter pub get && dart run icons_launcher:create && dart run flutter_native_splash:create