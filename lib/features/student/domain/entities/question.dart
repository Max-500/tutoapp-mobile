class Question {
  final String question;
  final List<String> options;
  bool isExpanded = false;


  Question({required this.question, required this.options});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      options: List<String>.from(map['options']),
    );
  }
  
}