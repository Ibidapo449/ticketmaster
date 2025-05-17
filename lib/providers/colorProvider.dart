import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Color> themeColors = [
  Color(0xFF004EE9), // blue
  Color(0xFFDE6035), // orange
];

class ColorProvider extends ChangeNotifier {
  static const _prefKey = 'selected_theme_color';

  /// Start with a default; we’ll overwrite if we find a saved one.
  Color _currentColor = themeColors[0];
  Color get currentColor => _currentColor;
 bool get isOrange => _currentColor == themeColors[1];
  ColorProvider() {
    _loadFromPrefs();
  }

  /// Toggle between your two themeColors
 void toggle() {
    _currentColor = isOrange ? themeColors[0] : themeColors[1];
    notifyListeners();
    _saveToPrefs();
  }

  /// Explicitly set to any color in your list
  void setColor(Color newColor) {
    if (newColor == _currentColor) return;
    _currentColor = newColor;
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final intValue = prefs.getInt(_prefKey);
    if (intValue != null) {
      _currentColor = Color(intValue);
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _currentColor.value);
  }
}
