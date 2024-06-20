import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/presentation/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  late double screenHeight;
  late double screenWidth;
  late double fontSizeTitle;
  late double fontSizeSubtitle;
  late double fontSizeText;
  late String _selectedValue;

  @override
  void initState(){
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

  final List<String> _options = ['Tutor', 'Estudiante'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LabelCustomized(text: 'TutoApp', color: const Color.fromRGBO(118, 10, 120, 1), fontSize: fontSizeTitle, weight: FontWeight.bold),
          
              IconApp(width: screenWidth * 0.5, height: screenHeight * 0.25),
                
              SizedBox(height: screenHeight*0.025,),
            
              LabelCustomized(text: 'Registrate', color: Colors.black, fontSize: fontSizeSubtitle, weight: FontWeight.normal),
            
              SizedBox(height: screenHeight*0.025,),
          
              SizedBox(
                  width: screenWidth * 0.7,
                  child: const TextFieldCustomized(text: 'Nombre'),
              ),
            
              SizedBox(height: screenHeight*0.025,),
          
              SizedBox(
                  width: screenWidth * 0.7,
                  child: const TextFieldCustomized(text: 'Apellido'),
              ),
            
              SizedBox(height: screenHeight*0.025,),
          
              SizedBox(
                  width: screenWidth * 0.7,
                  child: const TextFieldCustomized(text: 'Correo Electronico'),
              ),
            
              SizedBox(height: screenHeight*0.025,),
          
              SizedBox(
                  width: screenWidth * 0.7,
                  child: const TextFieldCustomized(text: 'Contraseña', isPassword: true,),
              ),
            
              SizedBox(height: screenHeight*0.025,),
          
              SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.075,
                child: ElevatedButtonCustomized(
                  child: Text('Registrarse', style: TextStyle(color: Colors.white, fontSize: fontSizeText) ,),
                  onPressed: () => context.push('/'),
                ),
              ),

              SizedBox(height: screenHeight*0.025,),

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

            SizedBox(height: screenHeight*0.025,),

            RichTextLink(onPressed: () => context.push('/'), text1: '¿Ya tienes una cuenta? ', text2: 'Inicia Ahora', size: screenWidth * 0.04)

            ],
          ),
        ),
      ),
    );
  }
}