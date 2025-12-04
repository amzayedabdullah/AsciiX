import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const ThemeSwitcher({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
      onPressed: onToggle,
    );
  }
}
