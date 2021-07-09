import 'package:flutter/material.dart';
import 'utils/utils.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    Styles.isDark = value;
    notifyListeners();
  }

  void toggleDarkTheme([bool? value]) => darkTheme = value ?? !_darkTheme;
}
