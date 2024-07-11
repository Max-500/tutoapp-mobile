import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _userUUIDKey = 'user_uuid';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _isNewUserKey = 'is_new_user';

  static Future<void> saveUser(String uuid, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, uuid);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userRoleKey, role);
    await prefs.setBool(_isNewUserKey, false);
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final email = prefs.getString(_userEmailKey);
    final role = prefs.getString(_userRoleKey);
    final isNewUser = prefs.getBool(_isNewUserKey) ?? true;
    return {'uuid': uuid, 'email': email, 'role': role, 'isNewUser': isNewUser};
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_isNewUserKey);
  }
}