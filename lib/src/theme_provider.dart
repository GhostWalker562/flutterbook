import 'package:flutter/material.dart';
import 'utils/utils.dart';

class ThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  bool _isUsingListOfThemes = false;

  int _activeThemeIndex = 0;

  int get activeThemeIndex => _activeThemeIndex;

  bool get darkTheme => _darkTheme;

  bool get isUsingListOfThemes => _isUsingListOfThemes;

  List<String> themeNames = [];

  set darkTheme(bool value) {
    _darkTheme = value;
    Styles.isDark = value;
    notifyListeners();
  }

  ThemeProvider({useListOfThemes = false, this.themeNames = const []}) {
    _isUsingListOfThemes = useListOfThemes;
  }

  void toggleDarkTheme([bool? value]) => darkTheme = value ?? !_darkTheme;

  void onChangeActiveThemeIndex(int index) {
    _activeThemeIndex = index;
    notifyListeners();
  }
}
