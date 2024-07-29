import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/student/data/datasources/student_remote_data_source_impl.dart';
import 'package:tuto_app/features/student/data/repositories/student_repository_impl.dart';
import 'package:tuto_app/features/student/domain/usecases/get_profile_image.dart';
import 'package:tuto_app/features/student/domain/usecases/get_schedule_tutor.dart';
import 'package:tuto_app/features/student/domain/usecases/permission.dart';
import 'package:tuto_app/features/student/domain/usecases/save_data_general.dart';
import 'package:tuto_app/features/student/domain/usecases/save_type_learning.dart';
import 'package:tuto_app/features/student/domain/usecases/update_profile_image.dart';
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

final getSheduleTutorProvider = Provider<GetScheduleTutor>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return GetScheduleTutor(repository: repository);
});

final getProfileImageProvider = Provider<GetProfileImage>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return GetProfileImage(repository: repository);
});

final permissionProvider = Provider<Permission>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return Permission(repository: repository);
});

final updateProfileImageProvider = Provider<UpdateProfileImage>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return UpdateProfileImage(repository: repository);
});