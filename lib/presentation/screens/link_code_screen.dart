import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';
import 'package:tuto_app/widgets.dart';

class LinkCodeScreen extends StatefulWidget {
  const LinkCodeScreen({super.key});

  @override
  State<LinkCodeScreen> createState() => _LinkCodeScreenState();
}

class _LinkCodeScreenState extends State<LinkCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSizeTitle = screenWidth * 0.12;
    final double fontSizeSubtitle = screenWidth * 0.09;
    final double fontSizeText = screenWidth * 0.06;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Consumer(
              builder: (context, ref, child) {
                final vinculeTutor = ref.read(vinculeTutorProvider);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [   
                    LabelCustomized(text: 'TutoApp', color: const Color.fromRGBO(118, 10, 120, 1), fontSize: fontSizeTitle, weight: FontWeight.bold),
              
                    IconApp(width: screenWidth * 0.5, height: screenHeight * 0.25),
                  
                    SizedBox(height: screenHeight*0.025,),
              
                    LabelCustomized(text: 'Bienvenido', color: Colors.black, fontSize: fontSizeSubtitle, weight: FontWeight.normal),
              
                    SizedBox(height: screenHeight*0.025,),
              
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: TextFormFieldCustomized(controller: codeController, hintText: 'Codigo', validator: (value) {
                        if(value == null || value.length != 9 || value.isEmpty) {
                          return 'Ingresa un codigo valido (9 caracteres)';
                        }
                        return null;
                      }, filled: true),
                    ),
              
                    SizedBox(height: screenHeight*0.05,),
              
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.075,
                      child: ElevatedButtonCustomized(
                        child: Text('Vincular', style: TextStyle(color: Colors.white, fontSize: fontSizeText) ,),
                        onPressed: () async {
                          if(!formKey.currentState!.validate()) {
                            return;
                          }
                          try {
                            await vinculeTutor(codeController.text);
                            // ignore: use_build_context_synchronously
                            context.go('/home-student');
                          } catch(e) {
                            showToast(e.toString());
                          }
                        },
                      ),
                    ),
                ],);
              },
            
            ),
          ),
        ),
      ),
    );
  }
}