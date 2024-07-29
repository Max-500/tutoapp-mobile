import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/repositories/student_repository.dart';

class UpdateProfileImage {
  final StudentRepository repository;

  UpdateProfileImage({required this.repository});

  Future<String> call(XFile file) async {
    final student = await SharedPreferencesServiceStudent.getStudent();
    return await repository.updateProfileImage(student['userUUID'], file);
  }
}