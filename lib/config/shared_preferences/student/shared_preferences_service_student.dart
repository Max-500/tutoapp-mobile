import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceStudent {
  static const String _userUUIDKey = 'user_uuid'; // String
  static const String _haveATutor = 'have_tutor'; // bool
  static const String _generalData = 'general_data'; // bool
  static const String _typeLearning = 'type_learning'; // bool
  static const String _userUUIDTutor = 'user_uuid_tutor'; // String

  static Future<void> saveStudent(String userUUID, String haveATutor, bool generalData, bool typeLearning) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userUUIDKey, userUUID);
    prefs.setString(_haveATutor, haveATutor);
    prefs.setBool(_generalData, generalData);
    prefs.setBool(_typeLearning , typeLearning);
  }

  static Future<void> vinculeTutor(bool haveATutor, String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_haveATutor, true);
    prefs.setString(_userUUIDTutor, uuid);
  }

  static Future<void> setGeneralData(bool generalData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_generalData, generalData);
  }

  static Future<void> setTypeLearning(bool typeLearning) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_typeLearning, typeLearning);
  }

  static Future<Map<String, dynamic>> getStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString(_userUUIDKey);
    final haveATutor = prefs.getString(_haveATutor);
    final generalData = prefs.getBool(_generalData);
    final typeLearning = prefs.getBool(_typeLearning);
    final userUUIDTutor = prefs.getString(_userUUIDTutor);
    return { 'userUUID': uuid, 'haveATutor': haveATutor, 'generalData': generalData, 'typeLearning': typeLearning, 'userUUIDTutor': userUUIDTutor };
  }

  static Future<void> clearStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUUIDKey);
    await prefs.remove(_haveATutor);
    await prefs.remove(_generalData);
    await prefs.remove(_typeLearning);
    // Aqui se añadira el tutorUUID
  }

}