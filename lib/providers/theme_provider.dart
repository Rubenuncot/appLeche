import 'package:flutter/material.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';
import 'package:transportes_leche/theme/theme_main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  String currentThemeName = 'light';

  ThemeProvider({required bool isDarkMode})
      : currentTheme = isDarkMode ? ThemeMain.darkTheme : ThemeMain.lightTheme,
        currentThemeName = isDarkMode ? 'dark' : 'light';

  setLightMode() {
    Preferences.theme = false;
    currentTheme = ThemeMain.lightTheme;
    currentThemeName = 'light';
    notifyListeners();
  }

  setDarktMode() {
    Preferences.theme = true;
    currentTheme = ThemeMain.darkTheme;
    currentThemeName = 'dark';
    notifyListeners();
  }
}