import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/student/data/datasources/student_remote_data_source_impl.dart';
import 'package:tuto_app/features/student/data/repositories/student_repository_impl.dart';
import 'package:tuto_app/features/student/domain/usecases/save_data_general.dart';
import 'package:tuto_app/features/student/domain/usecases/save_type_learning.dart';
import 'package:tuto_app/features/student/domain/usecases/vincule_tutor.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final studentRemoteDataSourceProvider = Provider<StudentRemoteDataSourceImpl>((ref) {
  final client = ref.watch(httpClientProvider);
  return StudentRemoteDataSourceImpl(client: client);
});

final studentRepositoryProvider = Provider<StudentRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(studentRemoteDataSourceProvider);
  return StudentRepositoryImpl(remoteDataSource: remoteDataSource);
});

final saveDataGeneralProvider = Provider<SaveDataGeneral>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return SaveDataGeneral(repository: repository);
});

final saveTypeLearningProvider = Provider<SaveTypeLearning>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return SaveTypeLearning(repository: repository);
});

final vinculeTutorProvider = Provider<VinculeTutor>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return VinculeTutor(repository: repository);
});