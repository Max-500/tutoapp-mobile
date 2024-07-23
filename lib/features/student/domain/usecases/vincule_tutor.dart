import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class VinculeTutor {
  final StudentRepository repository;

  VinculeTutor({required this.repository});

  Future<String> call(String code) async {
    final student = await SharedPreferencesServiceStudent.getStudent();
    return await repository.vinculeTutor(student['userUUID'], code);
  }
  
}