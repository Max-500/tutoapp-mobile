import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceStudent {
  static const String _userUUIDKey = 'student_user_uuid';
  static const String _haveATutorKey = 'student_have_tutor';
  static const String _generalDataKey = 'student_general_data';
  static const String _typeLearningKey = 'student_type_learning';
  static const String _tokenStudent = 'token_student';

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Método para guardar datos del estudiante
  static Future<void> saveStudent(String userUUID, String haveATutor, bool generalData, bool typeLearning, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, userUUID);
    await prefs.setString(_haveATutorKey, haveATutor);
    await prefs.setBool(_generalDataKey, generalData);
    await prefs.setBool(_typeLearningKey, typeLearning);
    await _secureStorage.write(key: _tokenStudent, value: token);
  }

  // Método para vincular tutor
  static Future<void> vinculeTutor(String haveATutor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_haveATutorKey, haveATutor);
  }

  // Método para establecer datos generales
  static Future<void> setGeneralData(bool generalData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_generalDataKey, generalData);
  }

  // Método para establecer tipo de aprendizaje
  static Future<void> setTypeLearning(bool typeLearning) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_typeLearningKey, typeLearning);
  }

  // Método para obtener datos del estudiante
  static Future<Map<String, dynamic>> getStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final haveATutor = prefs.getString(_haveATutorKey);
    final generalData = prefs.getBool(_generalDataKey);
    final typeLearning = prefs.getBool(_typeLearningKey);
    return {
      'userUUID': uuid,
      'haveATutor': haveATutor,
      'generalData': generalData,
      'typeLearning': typeLearning,
    };
  }

  // Método para eliminar datos del estudiante
  static Future<void> clearStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_haveATutorKey);
    await prefs.remove(_generalDataKey);
    await prefs.remove(_typeLearningKey);
    await _secureStorage.delete(key: _tokenStudent); // Eliminar también el token almacenado de forma segura
  }

  // Método para obtener el token del estudiante
  static Future<String> getToken() async {
    return await _secureStorage.read(key: _tokenStudent) ?? '';
  }
}
