import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/widgets.dart';

class TutoredScreen extends StatelessWidget {
  final TutoredModel tutored;

  const TutoredScreen({super.key, required this.tutored});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/icono.svg', height: 30),
            const SizedBox(width: 10),
            const Text(
              'Tutorados',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: _Tutored(
          tutored: tutored,
        ),
      ),
    );
  }
}

class _Tutored extends StatelessWidget {
  final TutoredModel tutored;

  const _Tutored({
    required this.tutored,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.04;


    return Center(
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.25,
            height: screenHeight * 0.15,
            child: tutored.profileImage == 'PENDING'? 
              Image.asset('images/perfil.png',fit: BoxFit.contain)
              : Image.network(tutored.profileImage, fit: BoxFit.contain,)
          ),
          Text('Matricula', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.matricula, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85,),
          
          SizedBox(height: screenHeight * 0.02,),

          Text('Nombre', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.fullname, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85),
          SizedBox(height: screenHeight * 0.02,),

          Text('Grado y grupo', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.gradeAndGroup, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85),
          SizedBox(height: screenHeight * 0.02,),

          Text('Número de telefono personal', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.phoneNumer, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85),
          SizedBox(height: screenHeight * 0.02,),

          Text('Número de telefono familiar', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.homePhone, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85),
          SizedBox(height: screenHeight * 0.02,),

          Text('Número de seguridad social', style: TextStyle(fontSize: fontSizeText), textAlign: TextAlign.center,),
          LabeledContainer(text: tutored.nss, weight: FontWeight.w300, sizeHeight: screenHeight * 0.06, sizeWidth: screenWidth * 0.85),
          SizedBox(height: screenHeight * 0.02,),

          SizedBox(
            height: screenHeight * 0.06,
            width: screenWidth * 0.25,
            child: ElevatedButtonCustomized(
              onPressed: () => context.pop(),
              child: const Icon(Icons.arrow_back,color: Colors.white,),
              ),
            ),
        ],
      ),
    );
  }
}
