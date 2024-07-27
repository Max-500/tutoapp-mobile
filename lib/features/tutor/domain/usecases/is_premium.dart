import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class IsPremium {
  final TutorRepository repository;

  IsPremium({required this.repository});

  Future<bool> call() async {
    return await repository.isPremium();
  }
}