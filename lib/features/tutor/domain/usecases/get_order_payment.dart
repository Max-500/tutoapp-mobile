import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetOrderPayment {
  final TutorRepository repository;

  GetOrderPayment({required this.repository});

  Future call() async {
    return await repository.getOrder();
  }
}