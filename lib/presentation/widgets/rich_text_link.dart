import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextLink extends StatelessWidget {
  final String text1;
  final String text2;
  final double size;
  final VoidCallback onPressed;

  const RichTextLink({super.key, required this.onPressed, required this.text1, required this.text2, required this.size});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text1, style: TextStyle(
            color: Colors.black, 
            fontSize: size, 
            fontFamily: 'Gelasio'
            )
          ),
          TextSpan(text: text2, style: TextStyle(
            color: Colors.black, 
            fontSize: size, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Gelasio'
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed
          )
        ]
      ),
    );
  }
}