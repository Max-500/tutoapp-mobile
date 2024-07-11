import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:tuto_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:tuto_app/features/auth/domain/usecases/login_user.dart';
import 'package:tuto_app/features/auth/domain/usecases/register_user.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final userRemoteDataSourceProvider = Provider<UserRemoteDataSourceImpl>((ref) {
  final client = ref.watch(httpClientProvider);
  return UserRemoteDataSourceImpl(client: client);
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});

final registerUserProvider = Provider<RegisterUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return RegisterUser(repository: repository);
});

final loginUserProvider = Provider<LoginUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginUser(repository: repository);
});
