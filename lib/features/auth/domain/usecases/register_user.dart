import 'package:tuto_app/features/auth/domain/entities/user.dart';
import 'package:tuto_app/features/auth/domain/repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser({ required this.repository });

  Future<dynamic> call(User user) async {
    return await repository.register(user);
  }
}