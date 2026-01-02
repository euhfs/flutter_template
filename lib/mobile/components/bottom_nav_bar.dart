import 'package:flutter/material.dart';
import '../../utils/custom_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>();
    return SafeArea(
      child: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: colors?.primary, size: 28),
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: selectedIndex,
        onTap: onTabChange,
      ),
    );
  }
}
