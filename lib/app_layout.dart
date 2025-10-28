import 'package:flutter/material.dart';

import 'desktop/main_screen_desktop.dart';
import 'mobile/main_screen_mobile.dart';

// This decides if it should build the mobile or desktop ui
class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // TODO: Adjust width as you like
    if (width >= 850) {
      return const MainScreenDesktop();
    } else {
      return const MainScreenMobile();
    }
  }
}
