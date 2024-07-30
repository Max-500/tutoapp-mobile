import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceTutor {
  static const String _userUUIDKey = 'tutor_user_uuid'; // Cambiado
  static const String _codeKey = 'tutor_code'; // Cambiado
  static const String _tokenTutor = 'token_tutor';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Método para guardar datos del usuario
  static Future<void> saveUser(String uuid, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, uuid);
    await _secureStorage.write(key: _tokenTutor, value: token);
  }

  // Método para guardar código
  static Future<void> saveCode(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_codeKey, code);
  }

  // Método para obtener datos del usuario
  static Future<Map<String, dynamic>> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final code = prefs.getString(_codeKey);
    return {'uuid': uuid, 'code': code};
  }

  // Método para obtener código
  static Future<String> getCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_codeKey) ?? '';
  }

  // Método para eliminar datos del usuario
  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_codeKey);
    await _secureStorage.delete(key: _tokenTutor); // Eliminar también el token almacenado de forma segura
  }

  // Método para obtener el token del tutor
  static Future<String> getToken() async {
    return await _secureStorage.read(key: _tokenTutor) ?? '';
  }
}
