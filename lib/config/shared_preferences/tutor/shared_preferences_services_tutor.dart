import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceTutor {
  static const String _userUUIDKey = 'tutor_user_uuid'; // Cambiado
  static const String _codeKey = 'tutor_code'; // Cambiado
  static const String _tokenTutor = 'token_tutor';

  static Future<void> saveUser(String uuid, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, uuid);
    await prefs.setString(_tokenTutor, token);
  }

  static Future<void> saveCode(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_codeKey, code);
  }

  static Future<Map<String, dynamic>> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final code = prefs.getString(_codeKey);
    return {'uuid': uuid, 'code': code};
  }

  static Future<String> getCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_codeKey) ?? '';
  }

  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_codeKey);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTutor) ?? '';
  }
}