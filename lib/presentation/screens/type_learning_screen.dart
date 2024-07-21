// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/student/domain/entities/question.dart';
import 'package:tuto_app/presentation/providers/student/question_provider.dart';

class TypeLearningScreen extends ConsumerStatefulWidget {
  final int currentPage;

  const TypeLearningScreen({super.key, required this.currentPage});

  @override
  _TypeLearningScreenState createState() => _TypeLearningScreenState();
}

class _TypeLearningScreenState extends ConsumerState<TypeLearningScreen> {
  bool isLoading = true;
  final int questionPerPage = 8;
  List<String> values = ['a', 'b', 'c'];
  late List<Question> questions;
  late List<String?> selectOptions;
  late List<bool> isExpanded;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void didUpdateWidget(TypeLearningScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      loadQuestions();
    }
  }

  Future<void> loadQuestions() async {
    final getQuestions = ref.read(getQuestionsProvider);
    questions = await getQuestions(widget.currentPage);

    final answers = ref.read(answersProvider.notifier).state;
    final int startIndex = (widget.currentPage - 1) * questionPerPage;
    final int endIndex = startIndex + questionPerPage;
    if (answers.length < endIndex) {
      answers.addAll(List<String>.filled(endIndex - answers.length, ''));
    }

    selectOptions = answers.sublist(startIndex, endIndex).map((e) => e == '' ? null : e).toList();

    isExpanded = List<bool>.filled(questions.length, false);
    isExpanded[0] = true;

    setState(() {
      isLoading = false;
    });
  }

  void handleSubmit() {
    final int startIndex = (widget.currentPage - 1) * questionPerPage;
    final currentAnswers = ref.read(answersProvider.notifier).state;

    for (int i = 0; i < selectOptions.length; i++) {
      currentAnswers[startIndex + i] = selectOptions[i] ?? '';
    }

    ref.read(answersProvider.notifier).state = currentAnswers;

    if (widget.currentPage < 5) {
      context.go('/type-learning/${widget.currentPage + 1}');
    } else {
      // Llamar a la API con las respuestas
    }
  }

  void updateExpansion() {
    for (int j = 0; j < questions.length; j++) {
      questions[j].isExpanded = false;
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Encuesta',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for (int index = 0; index < questions.length; index++)
                ExpansionTile(
                  key: PageStorageKey<int>(index),
                  initiallyExpanded: isExpanded[index],
                  title: Text(questions[index].question),
                  children: <Widget>[
                    for (int i = 0; i < questions[index].options.length; i++)
                      RadioListTile(
                        value: values[i],
                        groupValue: selectOptions[index],
                        title: Text(questions[index].options[i]),
                        onChanged: (value) {
                          setState(() {
                            selectOptions[index] = value;
                          });
                        },
                      ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    updateExpansion();
                    questions[index].isExpanded = expanded;
                  },
                ),
              SizedBox(height: screenHeight * 0.05,),
              SizedBox(
                width: screenWidth * 0.3,
                child: ElevatedButton.icon(
                  onPressed: handleSubmit,
                  icon: const Icon(Icons.arrow_forward_outlined, color: Colors.white),
                  label: Container(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(118, 10, 120, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
