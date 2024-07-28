import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class SaveOrderPayment {
  final TutorRepository repository;

  SaveOrderPayment({required this.repository});

  Future saveOrderPayment(String transactionId) async {
    await repository.getPremium(transactionId);
  }
}