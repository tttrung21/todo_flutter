import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/shared/configs.dart';

class LocaleHelper {

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Configs.languageKey);
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Configs.languageKey, languageCode);
  }
}
