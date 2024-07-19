import 'package:flutter/material.dart';
import 'package:tuto_app/widgets.dart';
import 'package:flutter/services.dart';

class HomeScreenTutor extends StatelessWidget {
  final String code;

  const HomeScreenTutor({super.key, required this.code});

  void _showSnackbar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'OK', onPressed: () {}),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color.fromRGBO(111, 12, 113, 1),
    );
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.07;
    final double responsiveIcon = screenWidth * 0.07;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
      ),
      drawer: const SideMenu(isTutor: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeText),),
            SizedBox(height: screenHeight * 0.05,),
            LabeledContainer(text: 'Codigo: $code', iconButton: IconButton(
                  icon: Icon(Icons.content_copy_outlined, size: responsiveIcon, color: const Color.fromRGBO(111, 12, 113, 1)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    _showSnackbar(context, 'Copied to Clipboard');
            },
            ),),
            SizedBox(height: screenHeight * 0.05,),
          ],
        ),
      ),
    );
  }
}