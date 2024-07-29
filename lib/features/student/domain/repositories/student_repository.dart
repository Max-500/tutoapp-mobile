abstract class StudentRepository {
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss);
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning);
  Future<String> vinculeTutor(String userUUID, String code);
  Future<String> getScheduleTutor(String tutorUUID);
  Future<String> getProfileImage(String userUUID);
  Future<String> permission(String userUUID, String tutorUUID);
}