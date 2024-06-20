import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/presentation/widgets.dart';

class LinkCodeScreen extends StatelessWidget {
  const LinkCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSizeTitle = screenWidth * 0.12;
    final double fontSizeSubtitle = screenWidth * 0.09;
    final double fontSizeText = screenWidth * 0.06;

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          LabelCustomized(text: 'TutoApp', color: const Color.fromRGBO(118, 10, 120, 1), fontSize: fontSizeTitle, weight: FontWeight.bold),

          IconApp(width: screenWidth * 0.5, height: screenHeight * 0.25),
          
          SizedBox(height: screenHeight*0.025,),

          LabelCustomized(text: 'Bienvenido', color: Colors.black, fontSize: fontSizeSubtitle, weight: FontWeight.normal),

          SizedBox(height: screenHeight*0.025,),

          SizedBox(
            width: screenWidth * 0.7,
            child: const TextFieldCustomized(text: 'Codigo'),
          ),

          SizedBox(height: screenHeight*0.05,),


          SizedBox(
            width: screenWidth * 0.7,
            height: screenHeight * 0.075,
            child: ElevatedButtonCustomized(
              child: Text('Vincular', style: TextStyle(color: Colors.white, fontSize: fontSizeText) ,),
              onPressed: () => context.push('/'),
            ),
          ),
      ],),),
    );
  }
}