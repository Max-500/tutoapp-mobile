
import 'package:tuto_app/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:tuto_app/features/auth/domain/entities/user.dart';
import 'package:tuto_app/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<dynamic> register(User user) async {
    return await remoteDataSource.register(user.toJson());
  }

  @override
  Future<dynamic> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }
}
