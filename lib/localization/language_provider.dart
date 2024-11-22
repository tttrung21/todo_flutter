import 'package:flutter/material.dart';

import '../shared/locale_helper.dart';

class LanguageProvider with ChangeNotifier{
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    await LocaleHelper.setLanguage(languageCode);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    final languageCode = await LocaleHelper.getLanguage();
    print(languageCode);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
}