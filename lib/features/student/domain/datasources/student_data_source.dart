abstract class StudentDataSource {
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss);
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning);
  Future<String> vinculeTutor(String userUUID, String code);
}