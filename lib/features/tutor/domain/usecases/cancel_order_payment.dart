import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class CancelOrderPayment {
  final TutorRepository repository;

  CancelOrderPayment({required this.repository});

  Future call(String transactionId) async {
    await repository.cancelOrder(transactionId);
  }
}