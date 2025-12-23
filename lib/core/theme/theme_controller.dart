import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  // Singleton pattern for easy access if needed, though Provider is better
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;
  ThemeController._internal();

  ThemeMode _themeMode =
      ThemeMode.dark; // Default to dark as per "Cyber-Swing" vibe

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
