import 'package:flutter/material.dart';

class ElevatedButtonCustomized extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const ElevatedButtonCustomized({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      backgroundColor: const Color.fromRGBO(111, 12, 113, 1)
      ), 
      child: child
    );
  }
}