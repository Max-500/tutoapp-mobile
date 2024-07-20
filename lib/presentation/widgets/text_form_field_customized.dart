import 'package:flutter/material.dart';

class TextFormFieldCustomized extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? filled;
  final bool? obscureText;

  const TextFormFieldCustomized({super.key, required this.hintText, required this.controller, required this.validator, this.filled, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(      
      textAlign: TextAlign.center,
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: filled ?? false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: filled != null ? BorderSide.none : const BorderSide(color: Color.fromRGBO(111, 12, 113, 1),),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: filled != null ? BorderSide.none : const BorderSide(color: Color.fromRGBO(237, 62, 188, 1), width: 2.0,),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0,),
        ),
        errorBorder: OutlineInputBorder( // Cuando tiene el focus
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0,),
        ),
      ),
    );
  }
}