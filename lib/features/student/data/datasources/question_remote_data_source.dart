import 'package:tuto_app/constants/type_learning_questions.dart';
import 'package:tuto_app/features/student/domain/datasources/question_data_source.dart';
import 'package:tuto_app/features/student/domain/entities/question.dart';

class QuestionRemoteDataSourceImpl implements QuestionDataSource {
  final int questionsPerPage;

  QuestionRemoteDataSourceImpl({this.questionsPerPage = 8});

  @override
  Future<List<Question>> getQuestions(int page) async {
    List<Question> questions = questionsData.map((data) => Question.fromMap(data)).toList();

    int startIndex = (page - 1) * questionsPerPage;
    int endIndex = startIndex + questionsPerPage;

    endIndex = endIndex > questions.length ? questions.length : endIndex;

    return questions.sublist(startIndex, endIndex);
  }

}