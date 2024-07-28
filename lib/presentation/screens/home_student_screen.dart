import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';
import 'package:tuto_app/widgets.dart';

class HomeStudentScreen extends ConsumerWidget {
  const HomeStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeTitle = screenWidth * 0.06;
    final double fontSizeText = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarStudent(screenWidth: screenWidth,),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20, // Tamaño del círculo
              backgroundColor: Colors.white, // Fondo blanco
              child: CircleAvatar(
                radius: 18, // Tamaño de la imagen, más pequeño que el fondo
                backgroundImage: AssetImage('images/perfil.png'), // Reemplazar con la ruta de tu imagen
              ),
            ),
          ),
        ],
      ),
      drawer: const SideMenu(isTutor: false),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('¿Qué deseas hacer hoy?', style: TextStyle(fontSize: fontSizeTitle),),

          SizedBox(height: screenHeight * 0.1,),
          
          LabeledContainer(text: 'Visualizar Horarios', callback: () async {
            final getScheduleTutor = ref.read(getSheduleTutorProvider);
            try {
              final schedule = await getScheduleTutor();
              final encodedSchedule = Uri.encodeComponent(schedule);

              context.push('/schedule/$encodedSchedule');
            } catch (e) {
              showToast(e.toString());
            }
          }, sizeHeight: screenHeight * 0.1,),

          SizedBox(height: screenHeight * 0.05,),

          LabeledContainer(text: 'Solicitar Permiso', callback: () {
            
          }, sizeHeight: screenHeight * 0.1,),

          SizedBox(height: screenHeight * 0.15,),

          Text('Cree en ti y todo sera posible', style: TextStyle(fontSize: fontSizeText),)

      ],),),
    );
  }
}

class AppBarStudent extends StatelessWidget {
  final double screenWidth;

  const AppBarStudent({
    super.key,
    required this.screenWidth,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('images/icono.svg', height: 30),
          const SizedBox(width: 10),
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
