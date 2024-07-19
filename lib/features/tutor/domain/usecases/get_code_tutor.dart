import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetCodeTutor {
  final TutorRepository repository;

  GetCodeTutor({required this.repository});

  Future<String> call(String userUUID) async {
    return await repository.getCode(userUUID);
  }
}