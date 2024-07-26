import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/tutor/data/datasources/tutor_remote_data_source.dart';
import 'package:tuto_app/features/tutor/data/repositories/tutor_repository_impl.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_code_tutor.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_premium.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_tutoreds.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final tutorRemoteDataSourceProvider = Provider<TutorRemoteDataSourceImpl>((ref) {
  final client = ref.watch(httpClientProvider);
  return TutorRemoteDataSourceImpl(client: client);
});

final tutorRepositoryProvider = Provider<TutorRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(tutorRemoteDataSourceProvider);
  return TutorRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getCodeProvider = Provider<GetCodeTutor>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return GetCodeTutor(repository: repository);
});

final getPremiumProvider = Provider<GetPremium>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return GetPremium(repository: repository);
});

final getTutoredsProvider = Provider<GetTutoreds>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return GetTutoreds(repository: repository);
});