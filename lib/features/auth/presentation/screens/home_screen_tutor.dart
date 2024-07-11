import 'package:flutter/material.dart';

class HomeScreenTutor extends StatelessWidget {
  const HomeScreenTutor({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.06;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeText),)
          ],
        ),
      ),
    );
  }
}