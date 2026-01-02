import 'package:flutter/material.dart';
import 'components/app_bar.dart';
import 'components/bottom_nav_bar.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = const [HomePage(), SettingsPage()];

  // Title of pages
  final List<String> _titles = const ['Home', 'Settings'];

  // Update index
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
