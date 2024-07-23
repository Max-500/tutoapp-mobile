import 'package:flutter/material.dart';

class LabelPro extends StatelessWidget {
  const LabelPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10.0,
      right: -10.0,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(149, 99, 212, 1),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
