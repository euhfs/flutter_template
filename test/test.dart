import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ThemeMode.system;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      home: const Scaffold(body: Center(child: Text('Hello, Flutter!'))),
    );
  }
}
