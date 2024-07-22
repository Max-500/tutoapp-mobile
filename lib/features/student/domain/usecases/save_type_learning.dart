import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class SaveTypeLearning {
  final StudentRepository repository;

  SaveTypeLearning({required this.repository});

  Future<void> call(List<String> typeLearning) async {
    final student = await SharedPreferencesServiceStudent.getStudent();
    await repository.saveTypeLearning(student['userUUID'], typeLearning);
  }

}