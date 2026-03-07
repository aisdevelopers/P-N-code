import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static late Box _box;

  /// Initialize Hive box once
  static Future<void> init() async {
    _box = await Hive.openBox('app_storage');
  }

  /// Save data
  static Future<void> set(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Get data
  static T? get<T>(String key, {T? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  /// Remove item
  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  /// Clear all
  static Future<void> clear() async {
    await _box.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return _box.containsKey(key);
  }
}
