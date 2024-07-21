import 'package:tuto_app/features/student/domain/entities/question.dart';
import 'package:tuto_app/features/student/domain/repositories/question_repository.dart';

class GetQuestions {
  final QuestionRepository repository;

  GetQuestions({required this.repository});

  Future<List<Question>> call(int page) async {
    return await repository.getQuestions(page);
  }
}