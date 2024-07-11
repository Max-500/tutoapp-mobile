import 'package:tuto_app/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<dynamic> register(User user);
  Future<dynamic> login(String email, String password);
}