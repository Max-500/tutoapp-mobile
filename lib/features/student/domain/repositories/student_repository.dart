abstract class StudentRepository {
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss);
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning);
  Future<dynamic> vinculeTutor(String userUUID, String code);
}