import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class UpdateSchedule {
  final TutorRepository repository;

  UpdateSchedule({required this.repository});

  Future<String> call(XFile file) async {
    final tutor = await SharedPreferencesServiceTutor.getUser();
    return await repository.updateSchedule(tutor['uuid'], file);
  }
}