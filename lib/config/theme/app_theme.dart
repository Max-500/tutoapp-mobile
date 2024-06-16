import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Gelasio',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Gelasio'),
      bodyMedium: TextStyle(fontFamily: 'Gelasio'),
      displayLarge: TextStyle(fontFamily: 'Gelasio'),
      displayMedium: TextStyle(fontFamily: 'Gelasio'),
      displaySmall: TextStyle(fontFamily: 'Gelasio'),
      headlineMedium: TextStyle(fontFamily: 'Gelasio'),
      headlineSmall: TextStyle(fontFamily: 'Gelasio'),
      titleLarge: TextStyle(fontFamily: 'Gelasio'),
    ),
  );

}
