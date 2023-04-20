import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<bool> isDark() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    /// fyi: by default, we want dark mode, so returning true if null
    return prefs.getBool("is_dark") ?? true;
  }

  static Future<void> switchTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    /// fyi: if its dark, we change to light and vice versa
    prefs.setBool("is_dark", !isDark);
  }
}
