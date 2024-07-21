import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuto_app/features/student/data/datasources/question_remote_data_source.dart';
import 'package:tuto_app/features/student/data/repositories/question_repository_impl.dart';
import 'package:tuto_app/features/student/domain/usecases/get_questions.dart';

final questionRemoteDataSourceProvider = Provider<QuestionRemoteDataSourceImpl>((ref) {
  return QuestionRemoteDataSourceImpl();
});

final questionRepositoryProvider = Provider<QuestionRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(questionRemoteDataSourceProvider);
  return QuestionRepositoryImpl(remoteDatasource: remoteDataSource);
});

final getQuestionsProvider = Provider<GetQuestions>((ref) {
  final repository = ref.watch(questionRepositoryProvider);
  return GetQuestions(repository: repository);
});

final StateProvider<List<String?>> answersProvider = StateProvider((ref) => []);