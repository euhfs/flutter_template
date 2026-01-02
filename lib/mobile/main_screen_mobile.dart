import 'package:flutter/material.dart';
import 'package:tasks/mobile/pages/home_page.dart';
import 'package:tasks/mobile/pages/settings_page.dart';
import 'components/app_bar.dart';
import 'components/bottom_nav_bar.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // List of pages, add more only if you want that page to have a bottom navigation bar.
  final List<Widget> _pages = const [HomePage(), SettingsPage()];

  // These are the titles of those pages if you add more pages make sure to add more titles as well.
  final List<String> _titles = const ['Tasks', 'Notes'];

  // This updates the index of the current page you are in.
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This handles when you select an item in your navigation bar and animation
  void _onNavBarTap(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_selectedIndex]),
      body: PageView(controller: _pageController, onPageChanged: _onPageChanged, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(onTabChange: _onNavBarTap, selectedIndex: _selectedIndex),
    );
  }
}
