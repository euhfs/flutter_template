import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded)),
        ],
        currentIndex: selectedIndex,
        onTap: onTabChange,
      ),
    );
  }
}
