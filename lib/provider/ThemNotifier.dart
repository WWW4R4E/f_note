import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;

  ThemeNotifier() {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveSettings();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeModeIndex];
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setDouble('fontSize', _fontSize);
  }
}