import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceTutor {
  static const String _userUUIDKey = 'user_uuid';
  static const String _code = 'code';

  static Future<void> saveUser(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, uuid);
  }

  static Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_code, code);
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final code = prefs.getString(_code);
    return {'uuid': uuid, 'code': code };
  }

  static Future<String> getCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_code) ?? '';
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_code);
  }
}