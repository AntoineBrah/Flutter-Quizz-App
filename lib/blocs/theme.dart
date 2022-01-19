import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  bool isToggled = false;


  ThemeChanger(this._themeData);

  getTheme() => _themeData;
  getToggled() => isToggled;

  setTheme(ThemeData theme) {
    _themeData = theme;
    isToggled = !isToggled;

    notifyListeners();
  }
}