import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_permission_model.dart';
import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetTutoredsPermissions {
  final TutorRepository repository;

  GetTutoredsPermissions({required this.repository});

  Future<List<TutoredPermissionModel>> call() async {
    final tutor = await SharedPreferencesServiceTutor.getUser();
    return await repository.getTutoredsPermissions(tutor['uuid']);
  }
}