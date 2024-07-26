import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetTutoreds {
  final TutorRepository repository;

  GetTutoreds({required this.repository});

  Future<List<TutoredModel>> call() async {
    final tutor = await SharedPreferencesServiceTutor.getUser();
    return await repository.getTutoreds(tutor['uuid']);
  }
}