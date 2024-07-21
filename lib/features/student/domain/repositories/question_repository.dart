import 'package:tuto_app/features/student/domain/entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestions(int page);
}