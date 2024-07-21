import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceStudent {
  static const String _userUUIDKey = 'student_user_uuid'; // Cambiado
  static const String _haveATutorKey = 'student_have_tutor'; // Cambiado
  static const String _generalDataKey = 'student_general_data'; // Cambiado
  static const String _typeLearningKey = 'student_type_learning'; // Cambiado
  static const String _userUUIDTutorKey = 'student_user_uuid_tutor'; // Cambiado

  static Future<void> saveStudent(String userUUID, String haveATutor, bool generalData, bool typeLearning) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, userUUID);
    await prefs.setString(_haveATutorKey, haveATutor);
    await prefs.setBool(_generalDataKey, generalData);
    await prefs.setBool(_typeLearningKey, typeLearning);
  }

  static Future<void> vinculeTutor(bool haveATutor, String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_haveATutorKey, haveATutor);
    await prefs.setString(_userUUIDTutorKey, uuid);
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
    final userUUIDTutor = prefs.getString(_userUUIDTutorKey);
    return {
      'userUUID': uuid,
      'haveATutor': haveATutor,
      'generalData': generalData,
      'typeLearning': typeLearning,
      'userUUIDTutor': userUUIDTutor
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
}
