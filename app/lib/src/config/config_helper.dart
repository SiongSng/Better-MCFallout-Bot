import 'package:shared_preferences/shared_preferences.dart';

class ConfigHelper {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static T? get<T>(String key, {T? defaultValue}) {
    Object? value = _prefs.get(key) ?? defaultValue;
    if (value is T) {
      return value;
    } else {
      return null;
    }
  }

  static Future<void> set<T>(String key, T? value) async {
    if (value == null) {
      await _prefs.remove(key);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported config data type');
    }
  }
}
