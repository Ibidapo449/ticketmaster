import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Color> themeColors = [
  Color(0xFF004EE9), // blue
  Color(0xFFDE6035), // orange
  Color.fromARGB(255, 131, 131, 131),
  Colors.green,
  Colors.red,
  Colors.black
];

class ColorProvider extends ChangeNotifier {
  static const _prefKey = 'selected_theme_color';

  /// Start with a default; we’ll overwrite if we find a saved one.
  Color _currentColor = themeColors[0];
  Color get currentColor => _currentColor;
  bool get isPrimary => _currentColor == themeColors[0];
  ColorProvider() {
    _loadFromPrefs();
  }

  /// Toggle between your two themeColors
  void toggle() {
    final currentIndex = themeColors.indexOf(_currentColor);
    // If somehow _currentColor isn’t in the list, start at 0
    final nextIndex =
        (currentIndex < 0 ? 0 : (currentIndex + 1) % themeColors.length);
    setColor(themeColors[nextIndex]);
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
