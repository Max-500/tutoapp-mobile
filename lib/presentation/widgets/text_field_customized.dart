import 'package:flutter/material.dart';

class TextFieldCustomized extends StatelessWidget {
  final String text;

  const TextFieldCustomized({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
        filled: true,
        fillColor: const Color.fromRGBO(217, 217, 217, 0.7),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20))
        )
      ),
    );
  }
}