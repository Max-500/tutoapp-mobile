// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/entities/question.dart';
import 'package:tuto_app/presentation/providers/student/question_provider.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';

import '../../widgets.dart';

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
    questions[0].isExpanded = true;

    final answers = ref.read(answersProvider.notifier).state;
    final int startIndex = (widget.currentPage - 1) * questionPerPage;
    final int endIndex = startIndex + questionPerPage;

    // Ensure the answers list is large enough to hold all the answers
    if (answers.length < endIndex) {
      answers.addAll(List<String>.filled(endIndex - answers.length, ''));
    }

    // Map the answers for the current page to the selectOptions
    selectOptions = answers
        .sublist(startIndex, endIndex)
        .map((e) => e == '' ? null : e)
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  List<int> findNullIndices(List<dynamic> list) {
    List<int> nullIndices = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i] == null) {
        nullIndices.add(i);
      }
    }
    return nullIndices;
  }

  void handleSubmit() async {
    List<int> nullPositions = findNullIndices(selectOptions);
    if (selectOptions.contains(null)) {
      showMissingAnswersDialog(
          context, nullPositions, widget.currentPage, questionPerPage);
      return;
    }

    final int startIndex = (widget.currentPage - 1) * questionPerPage;
    final currentAnswers = ref.read(answersProvider.notifier).state;

    for (int i = 0; i < selectOptions.length; i++) {
      currentAnswers[startIndex + i] = selectOptions[i] ?? '';
    }

    ref.read(answersProvider.notifier).state = currentAnswers;

    if (widget.currentPage < 5) {
      context.push('/type-learning/${widget.currentPage + 1}');
      return;
    }
    List<String> nonNullableAnswers = ref
        .read(answersProvider.notifier)
        .state
        .where((element) => element != null)
        .cast<String>()
        .toList();

    final saveTypeLearning = ref.read(saveTypeLearningProvider);
    try {
      await saveTypeLearning(nonNullableAnswers);
      context.go('/acknowledgment');
    } on Exception catch (e) {
      showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''), context);
    }
  }

  void updateExpansion(int index, bool expanded) {
    setState(() {
      if (expanded) {
        for (int i = 0; i < questions.length; i++) {
          questions[i].isExpanded = i == index;
        }
      } else {
        questions[index].isExpanded = false;
      }
    });
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (_, index) {
                final globalIndex =
                    ((widget.currentPage - 1) * questionPerPage) + index;
                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ExpansionTile(
                    initiallyExpanded: questions[index].isExpanded,
                    key: UniqueKey(),
                    title: Text(
                        '${globalIndex + 1}.- ${questions[index].question}'),
                    children: [
                      for (int i = 0; i < questions[index].options.length; i++)
                        RadioListTile(
                          value: values[i],
                          groupValue: selectOptions[index],
                          title: Text(questions[index].options[i]),
                          onChanged: (value) {
                            setState(() {
                              selectOptions[index] = value;
                              ref
                                  .read(answersProvider.notifier)
                                  .state[globalIndex] = value!;
                            });
                          },
                        ),
                    ],
                    onExpansionChanged: (value) {
                      updateExpansion(index, value);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: screenHeight * 0.06,
              width: screenWidth * 0.3,
              child: ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(118, 10, 120, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Icon(Icons.arrow_forward_outlined,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
