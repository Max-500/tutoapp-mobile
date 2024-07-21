import 'package:flutter/material.dart';

class LabelCustomized extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight weight;
  final bool? center;

  const LabelCustomized({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.weight,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: center == true ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: weight,
      ),
    );
  }
}
