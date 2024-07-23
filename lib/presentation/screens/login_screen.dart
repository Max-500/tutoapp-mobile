// ignore_for_file: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/presentation/providers/auth/user_provider.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
import 'package:tuto_app/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    print(message);
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'ok!', onPressed: () {}),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
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
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabelCustomized(
                  text: 'TutoApp',
                  color: const Color.fromRGBO(118, 10, 120, 1),
                  fontSize: fontSizeTitle,
                  weight: FontWeight.bold,
                ),
                IconApp(width: screenWidth * 0.5, height: screenHeight * 0.25),
                SizedBox(height: screenHeight * 0.025),
                LabelCustomized(
                  text: 'Iniciar Sesión',
                  color: Colors.black,
                  fontSize: fontSizeSubtitle,
                  weight: FontWeight.normal,
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextFormFieldCustomized(
                    controller: _emailController,
                    hintText: 'Correo Electronico',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Por favor, ingrese su correo electronico*';
                      }
                      return null;
                    },
                    filled: true,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextFormFieldCustomized(
                    controller: _passwordController,
                    hintText: 'Contraseña',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Por favor, ingrese su contraseña*';
                      }
                      return null;
                    },
                    filled: true,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.075,
                  child: ElevatedButtonCustomized(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        final loginUser = ref.read(loginUserProvider);
                        try {
                          print('entro');
                          final response = await loginUser(email, password);
                          print(response);
                          if (response['user']['student'] != null) {
                            await SharedPreferencesServiceStudent.saveStudent(
                                response['user']['student']['userUUID'],
                                response['user']['student']['haveTutor'],
                                response['user']['generalDataBool'],
                                response['user']['typeLearningBool']);
                            if (!response['user']['generalDataBool']) {
                              context.go('/general-data');
                              return;
                            }
                            if (!response['user']['typeLearningBool']) {
                              context.go('/welcome');
                              return;
                            }
                            if (response['user']['student']['haveTutor'] == 'PENDING') {
                              context.go('/link-code');
                              return;
                            }
                            context.push('/home-student');
                            return;
                          } else {
                            final getCode = ref.read(getCodeProvider);
                            final code =
                                await getCode(response['user']['uuid']);
                            await SharedPreferencesServiceTutor.saveUser(
                                response['user']['uuid']);
                            await SharedPreferencesServiceTutor.saveCode(code);
                            context.go('/home-tutor/$code');
                          }
                        } catch (e) {
                          _showErrorSnackbar(
                              e.toString().replaceFirst('Exception: ', ''));
                        }
                      }
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeText),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                RichTextLink(
                  onPressed: () => context.push('/register'),
                  text1: '¿No tienes una cuenta? ',
                  text2: 'Registrate Ahora',
                  size: screenWidth * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
