import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class GetScheduleTutor {
  final StudentRepository repository;

  GetScheduleTutor({required this.repository});

  Future<String> call() async {
    final tutor = await SharedPreferencesServiceStudent.getStudent();
    return await repository.getScheduleTutor(tutor['haveATutor']);
  }
}