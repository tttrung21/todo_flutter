import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configs {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String languageKey = 'app_language';
}
