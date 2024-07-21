import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeTitle = screenWidth * 0.12;
    final double fontSizeText = screenWidth * 0.06;

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LabelCustomized(
            text: '¡Hola!',
            color: const Color.fromRGBO(118, 10, 120, 1),
            fontSize: fontSizeTitle,
            weight: FontWeight.bold,
          ),

          IconApp(width: screenWidth * 0.5, height: screenHeight * 0.25),

          SizedBox(height: screenHeight * 0.05),

          SizedBox(
            width: screenWidth * 0.7,
            child: LabelCustomized(
              text: 'En breve iniciaremos con una pequeña encuesta',
              color: Colors.black,
              fontSize: fontSizeText,
              weight: FontWeight.bold,
              center: true
            ),
          ),

          SizedBox(height: screenHeight * 0.05),

          SizedBox(
            width: screenWidth * 0.7,
            height: screenHeight * 0.075,
            child: ElevatedButtonCustomized(onPressed: () => context.push('/type-learning/1'), child: Text('Comenzar', style: TextStyle(color: Colors.white, fontSize: fontSizeText),))
          )
      ],),),
    );
  }
}