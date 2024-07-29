import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class Permission {
  final StudentRepository repository;

  Permission({required this.repository});

  Future<String> call() async {
    final student = await SharedPreferencesServiceStudent.getStudent();
    return await repository.permission(student['userUUID'], student['haveATutor']);
  }
}