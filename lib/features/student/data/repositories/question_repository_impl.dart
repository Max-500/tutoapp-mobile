import 'package:tuto_app/features/student/data/datasources/question_remote_data_source.dart';
import 'package:tuto_app/features/student/domain/entities/question.dart';
import 'package:tuto_app/features/student/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSourceImpl remoteDatasource;

  QuestionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Question>> getQuestions(int page) async {
    return await remoteDatasource.getQuestions(page);
  }

}