import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
      home: HomeScreen(
        onThemeToggle: () => setState(() => isDark = !isDark),
        isDark: isDark,
      ),
    );
  }
}
