import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/auth/presentation/providers/user_provider.dart';
import 'package:tuto_app/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
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
    final SnackBar snackBar = SnackBar(content: Text(message), action: SnackBarAction(label: 'ok!', onPressed: (){}), duration: const Duration(seconds: 3), backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(snackBar);
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
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Correo Electronico'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su correo electrónico';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su contraseña';
                      }
                      return null;
                    },
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
                          final response = await loginUser(email, password);
                          if(response['role'] == 'student') {
                              context.push('/link-code');
                              return;
                          }
                          context.go('/home-tutor');
                        } catch (e) {
                          _showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
                        }
                      }
                    },
                    child: Text('Entrar', style: TextStyle(color: Colors.white, fontSize: fontSizeText) ,),
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
