import 'package:tuto_app/features/auth/domain/repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser({required this.repository});

  Future<dynamic> call(String email, String password) async {
    return await repository.login(email, password);
  }
}