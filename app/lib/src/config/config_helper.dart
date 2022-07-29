import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ConfigHelper {
  static late final Box _box;

  static Future<void> init() async {
    Directory dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);

    _box = await Hive.openBox('config');
  }

  static dynamic get(String key) {
    return _box.get(key);
  }

  static Future<void> set(String key, dynamic value) async {
    await _box.put(key, value);
  }
}