import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Тонка обгортка над SharedPreferences для збереження JSON.
class JsonStore {
  JsonStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<JsonStore> create() async =>
      JsonStore(await SharedPreferences.getInstance());

  List<Map<String, dynamic>>? readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  String? readString(String key) => _prefs.getString(key);

  Future<void> writeString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
}
