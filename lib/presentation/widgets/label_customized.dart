import 'package:flutter/material.dart';

class LabelCustomized extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight weight;

  const LabelCustomized({super.key, required this.text, required this.color, required this.fontSize, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: weight
    ),);
  }
}