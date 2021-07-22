import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchTheme extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _pref;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;
  SwitchTheme() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  Future _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  Future _loadFromPrefs() async {
      await _initPrefs();
      _darkTheme = _pref.getBool(key) ?? true;
      notifyListeners();
  }

  Future _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }

}
