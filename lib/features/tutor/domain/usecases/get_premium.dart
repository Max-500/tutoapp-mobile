import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetPremium {
  final TutorRepository repository;

  GetPremium({required this.repository});

  Future<void> call(String transactionId) async {
    await repository.getPremium(transactionId);
  }
}