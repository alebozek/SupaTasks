import 'package:flutter/material.dart';

class ThemePicker extends StatelessWidget {
  final ThemeMode selectedTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemePicker({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.task, color: Colors.white,),
      initialValue: selectedTheme,
      onSelected: onThemeChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Text('Light'),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark'),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Text('System'),
        ),
      ],
    );
  }
}