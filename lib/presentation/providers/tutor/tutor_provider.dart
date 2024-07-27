import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/tutor/data/datasources/tutor_remote_data_source.dart';
import 'package:tuto_app/features/tutor/data/repositories/tutor_repository_impl.dart';
import 'package:tuto_app/features/tutor/domain/usecases/cancel_order_payment.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_code_tutor.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_order_payment.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_premium.dart';
import 'package:tuto_app/features/tutor/domain/usecases/get_tutoreds.dart';
import 'package:tuto_app/features/tutor/domain/usecases/is_premium.dart';
import 'package:tuto_app/features/tutor/domain/usecases/update_schedule.dart';

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

final getOrderPaymentProvider = Provider<GetOrderPayment>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return GetOrderPayment(repository: repository);
});

final cancelOrderPaymentProvider = Provider<CancelOrderPayment>((ref) {
  final repository =  ref.watch(tutorRepositoryProvider);
  return CancelOrderPayment(repository: repository);
});

final savePaymentProvider = Provider<GetPremium>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return GetPremium(repository: repository);
});

final isPremiumProvider = Provider<IsPremium>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return IsPremium(repository: repository);
});

final updateScheduleProvider = Provider<UpdateSchedule>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return UpdateSchedule(repository: repository);
});