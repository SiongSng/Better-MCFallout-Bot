import 'package:shared_preferences/shared_preferences.dart';

class ConfigHelper {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static dynamic get(String key) {
    return _prefs.get(key);
  }

  static Future<void> set(String key, dynamic value) async {
    if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    } else {
      throw Exception('Unsupported config data type');
    }
  }
}
