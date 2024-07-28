import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceStudent {
  static const String _userUUIDKey = 'student_user_uuid'; // Cambiado
  static const String _haveATutorKey = 'student_have_tutor'; // Cambiado
  static const String _generalDataKey = 'student_general_data'; // Cambiado
  static const String _typeLearningKey = 'student_type_learning'; // Cambiado
  static const String _tokenStudent = 'token_student';

  static Future<void> saveStudent(String userUUID, String haveATutor, bool generalData, bool typeLearning, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, userUUID);
    await prefs.setString(_haveATutorKey, haveATutor);
    await prefs.setBool(_generalDataKey, generalData);
    await prefs.setBool(_typeLearningKey, typeLearning);
    await prefs.setString(_tokenStudent, token);
  }

  static Future<void> vinculeTutor(String haveATutor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_haveATutorKey, haveATutor);
  }

  static Future<void> setGeneralData(bool generalData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_generalDataKey, generalData);
  }

  static Future<void> setTypeLearning(bool typeLearning) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_typeLearningKey, typeLearning);
  }

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

  static Future<void> clearStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_haveATutorKey);
    await prefs.remove(_generalDataKey);
    await prefs.remove(_typeLearningKey);
    // Aquí se añadirá el tutorUUID
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenStudent) ?? '';
  }
}