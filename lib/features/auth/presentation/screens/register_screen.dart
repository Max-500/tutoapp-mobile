import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/auth/domain/entities/user.dart';
import 'package:tuto_app/features/auth/presentation/providers/user_provider.dart';
import 'package:tuto_app/widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late double screenHeight;
  late double screenWidth;
  late double fontSizeTitle;
  late double fontSizeSubtitle;
  late double fontSizeText;
  late String _selectedValue;

  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final List<String> _options = ['Tutor', 'Estudiante'];

  @override
  void initState() {
    super.initState();
    _selectedValue = _options.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    fontSizeTitle = screenWidth * 0.12;
    fontSizeSubtitle = screenWidth * 0.09;
    fontSizeText = screenWidth * 0.06;
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showCustomSnackBar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text), action: SnackBarAction(label: 'ok!', onPressed: (){}), duration: const Duration(seconds: 3),);
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
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
                  text: 'Registrate',
                  color: Colors.black,
                  fontSize: fontSizeSubtitle,
                  weight: FontWeight.normal,
                ),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextFormField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  width: screenWidth * 0.7,
                  child: TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su apellido';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
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
                SizedBox(height: screenHeight * 0.025),
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
                SizedBox(height: screenHeight * 0.025),
                DropdownButton<String>(
                  value: _selectedValue,
                  hint: const Text('Selecciona una opción'),
                  items: _options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                  underline: Container(),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontFamily: 'Gelasio'),
                ),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.075,
                  child: ElevatedButtonCustomized(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final role = _selectedValue == 'Tutor' ? UserRole.tutor : UserRole.student;
                        final userRegistration = User(
                          uuid: '',
                          firstname: _firstnameController.text,
                          lastname: _lastnameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          role: role,
                        );

                        final registerUser = ref.read(registerUserProvider);
                        try {
                          await registerUser(userRegistration);
                          // ignore: use_build_context_synchronously
                          context.push('/');
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showCustomSnackBar(context, e.toString());
                        }
                      }
                    },
                    child: Text('Entrar', style: TextStyle(color: Colors.white, fontSize: fontSizeText) ,),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                RichTextLink(
                  onPressed: () => context.push('/'),
                  text1: '¿Ya tienes una cuenta? ',
                  text2: 'Inicia Ahora',
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