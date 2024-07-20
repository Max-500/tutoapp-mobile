import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class SaveDataGeneral {
  final StudentRepository repository;

  SaveDataGeneral({required this.repository});

  Future<void> call(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss) async {
    await repository.saveDataGeneral(userUUID, matricula, group, quarter, phoneNumer, homePhone, nss);
  }
}