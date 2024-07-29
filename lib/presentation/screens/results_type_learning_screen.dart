// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';

final pieChartProvider = StateNotifierProvider<PieChartNotifier, int>((ref) {
  return PieChartNotifier();
});

class PieChartNotifier extends StateNotifier<int> {
  PieChartNotifier() : super(-1);

  void updateTouchedIndex(int index) {
    state = index;
  }
}

class ResultsTypeLearningScreen extends ConsumerStatefulWidget {
  const ResultsTypeLearningScreen({super.key});

  @override
  _ResultsTypeLearningScreenState createState() => _ResultsTypeLearningScreenState();
}

class _ResultsTypeLearningScreenState extends ConsumerState<ResultsTypeLearningScreen> {
  late List<PieChartSectionData> _chartData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final tutor = await SharedPreferencesServiceTutor.getUser();
    final response = await http.get(Uri.parse("https://devsolutions.software/api/v1/students/get-all-percentaje/${tutor['uuid']}"), headers: {
        'Content-Type': 'application/json',
      },
    );

    if(response.statusCode != 200) return;

    final responseJson = jsonDecode(response.body);

    setState(() {
      _chartData = [
        PieChartSectionData(
          color: const Color(0xff0293ee),
          value: responseJson['Kinestésico'].toDouble(),
          title: '${responseJson['Kinestésico'].toString()}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
        PieChartSectionData(
          color: const Color(0xfff8b250),
          value: responseJson['Auditivo'].toDouble(),
          title: '${responseJson['Auditivo'].toString()}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
        PieChartSectionData(
          color: const Color(0xff845bef),
          value: responseJson['Visual'].toDouble(),
          title: '${responseJson['Visual'].toString()}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarTutor(screenWidth: screenWidth),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Gráfica',
                style: TextStyle(
                    fontSize: screenWidth * 0.06, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              _isLoading 
                  ? const CircularProgressIndicator()
                  : PieChartSample2(chartData: _chartData),
            ],
          ),
        ),
      ),
    );
  }
}

class PieChartSample2 extends ConsumerStatefulWidget {
  final List<PieChartSectionData> chartData;

  const PieChartSample2({super.key, required this.chartData});

  @override
  _PieChartSample2State createState() => _PieChartSample2State();
}

class _PieChartSample2State extends ConsumerState<PieChartSample2> {
  @override
  Widget build(BuildContext context) {
    final touchedIndex = ref.watch(pieChartProvider);
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        ref.read(pieChartProvider.notifier).updateTouchedIndex(-1);
                        return;
                      }
                      ref.read(pieChartProvider.notifier).updateTouchedIndex(
                        pieTouchResponse.touchedSection!.touchedSectionIndex,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(widget.chartData, touchedIndex),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Color(0xff0293ee),
                text: 'Kinestésico',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color(0xfff8b250),
                text: 'Auditivo',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color(0xff845bef),
                text: 'Visual',
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<PieChartSectionData> chartData, int touchedIndex) {
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return chartData[i].copyWith(
        titleStyle: chartData[i].titleStyle?.copyWith(fontSize: fontSize),
        radius: radius,
      );
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class AppBarTutor extends StatelessWidget {
  const AppBarTutor({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.school_outlined,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          'Aprendizaje',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
