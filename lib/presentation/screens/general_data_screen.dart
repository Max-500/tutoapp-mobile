// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';
import 'package:tuto_app/widgets.dart';

class GeneralDataScreen extends ConsumerWidget {
  static final formKey = GlobalKey<FormState>();

  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController nssController = TextEditingController();

  GeneralDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    String? validateNSS(String? value) {
      final nssPattern = RegExp(r'^\d{11}$');
      if (value == null || value.isEmpty) {
        return 'Por favor, ingrese su Número de Seguro Social';
      } else if (!nssPattern.hasMatch(value)) {
        return 'Número de Seguro Social no válido';
      }
      return null;
    }

    String? validateMobilePhone(String? value) {
      final phonePattern = RegExp(r'^\d{10}$');
      if (value == null || value.isEmpty) {
        return 'Por favor, ingrese su teléfono móvil';
      } else if (!phonePattern.hasMatch(value)) {
        return 'Número de teléfono móvil no válido';
      }
      return null;
    }

    String? validateHomePhone(String? value) {
      final phonePattern = RegExp(r'^\d{7}$|^\d{10}$');
      if (value == null || value.isEmpty) {
        return 'Por favor, ingrese su teléfono de casa';
      } else if (!phonePattern.hasMatch(value)) {
        return 'Número de teléfono de casa no válido';
      }
      return null;
    }

    String? validateMatricula(String? value) {
      final matriculaPattern = RegExp(r'^\d{1,15}$');
      if (value == null || value.isEmpty) {
        return 'Por favor, ingrese su matrícula';
      } else if (!matriculaPattern.hasMatch(value)) {
        return 'Máximo 6 dígitos numéricos';
      }
      return null;
    }

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSizeText = screenWidth * 0.06;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/icono.svg', height: 30,),
            const SizedBox(width: 10),
            const Text(
              'TutoApp',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Matricula'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Matricula',
                        controller: matriculaController,
                        validator: validateMatricula,
                      ),
                      SizedBox(height: screenHeight * 0.02,),

                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Cuatrimestre'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Cuatrimestre',
                        controller: quarterController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su cuatrimestre';
                          }
                          final twoDigitPattern = RegExp(r'^(1[0-8]|[1-9])$');
                          if(value.length > 2 || !twoDigitPattern.hasMatch(value)) {
                            return 'Cuatrimestre no válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02,),

                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Grupo'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Grupo',
                        controller: groupController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su grupo';
                          }
                          final lowercaseLetterPattern = RegExp(r'^[a-zA-Z]$');

                          if (value.length > 1 || !lowercaseLetterPattern.hasMatch(value)) {
                            return 'Grupo no válido';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02,),

                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Telefono Particular'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Telefono Particular',
                        controller: phoneController,
                        validator: validateMobilePhone,
                      ),
                      SizedBox(height: screenHeight * 0.02,),

                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Telefono Familiar'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Telefono Familiar',
                        controller: telephoneController,
                        validator: validateHomePhone
                      ),
                      SizedBox(height: screenHeight * 0.02,),

                      const Row(
                        children: [
                          SizedBox(width: 10,),
                          Text('Número de Seguro Social'),
                        ],
                      ),
                      TextFormFieldCustomized(
                        hintText: 'Número de Seguro Social',
                        controller: nssController,
                        validator: validateNSS,
                      ),
                      SizedBox(height: screenHeight * 0.05,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.075,
                            child: ElevatedButtonCustomized(
                              onPressed: () async {
                                if(!formKey.currentState!.validate()) {
                                  return;
                                }
                                formKey.currentState!.save();
                                try {
                                  final student = await SharedPreferencesServiceStudent.getStudent();
                                  final saveDataGeneral = ref.read(saveDataGeneralProvider);
                                  await saveDataGeneral(student['userUUID'], matriculaController.text, groupController.text, quarterController.text, phoneController.text, telephoneController.text, nssController.text);
                                  await SharedPreferencesServiceStudent.setGeneralData(true);
                                  if(!student['typeLearning']) {
                                    context.go('/type-learning');
                                    return;
                                  }

                                  if(student['haveATutor'] == 'PENDING') { 
                                    context.go('/link-code');
                                    return;
                                  }

                                  context.go('/home-student');
                                } catch (e) {
                                  showAlert(context, e.toString().replaceFirst('Exception: ', ''));
                                }
                              },
                              child: Text('Guardar', style: TextStyle(color: Colors.white, fontSize: fontSizeText)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
    void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}