import 'package:shared_preferences/shared_preferences.dart';

class LocaleHelper {
  static const String languageKey = 'app_language';

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey);
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, languageCode);
  }
}
