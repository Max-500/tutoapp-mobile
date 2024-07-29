import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class GetProfileImage {
  final StudentRepository repository;

  GetProfileImage({required this.repository});

  Future<String> call() async {
    final student = await SharedPreferencesServiceStudent.getStudent();
    return await repository.getProfileImage(student['userUUID']);
  }
}