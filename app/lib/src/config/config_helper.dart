import 'dart:convert';

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
    if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported config data type');
    }
  }
}
