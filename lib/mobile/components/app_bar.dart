import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(scrolledUnderElevation: 0.0, title: Text(title), actions: []);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
