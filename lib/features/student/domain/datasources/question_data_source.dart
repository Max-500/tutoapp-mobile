import 'package:tuto_app/features/student/domain/entities/question.dart';

abstract class QuestionDataSource {
  Future<List<Question>> getQuestions(int page);
}