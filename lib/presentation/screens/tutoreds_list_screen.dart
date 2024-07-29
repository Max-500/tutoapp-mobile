import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/widgets.dart';

class TutoredsListScreen extends StatelessWidget {

  final List<TutoredModel> tutoreds;

  const TutoredsListScreen({super.key, required this.tutoreds});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.025,
          ),
          Expanded(
              child: _ListTuroreds(
            listTutoreds: tutoreds,
          )),
          Padding(
            padding:  EdgeInsets.only(bottom: screenHeight * 0.075),
            child: SizedBox(
              height: screenHeight * 0.06,
              width: screenWidth * 0.25,
              child: ElevatedButtonCustomized(
                onPressed: () async {
                  final tutor = await SharedPreferencesServiceTutor.getUser();
                  context.go('/home-tutor/${tutor['code']}');
                },
                child: const Icon(
                  Icons.arrow_back, // Icono de flecha hacia la izquierda
                  color: Colors.white, // Color del icono
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class _ListTuroreds extends StatelessWidget {
  final List<TutoredModel> listTutoreds;

  const _ListTuroreds({required this.listTutoreds});

  String procesarNombre(String nombreCompleto) {
    final nombres = nombreCompleto.split(' ');
    final primerNombre = nombres[0];
    
    if (nombreCompleto.length <= 3 || nombres.length <= 2) return nombreCompleto;

    final iniciales = nombres.sublist(1, nombres.length - 2);
    final abreviaciones = iniciales.map((nombre) => nombre[0]).join('. ');
    return '$primerNombre $abreviaciones. ${nombres[nombres.length - 2]} ${nombres[nombres.length - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.04;

    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
          height: screenHeight * 0.1,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(217, 217, 217, 0.7),
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              context.push('/tutored', extra: listTutoreds[index]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: listTutoreds[index].profileImage == "PENDING"
                          ? Image.asset('images/perfil.png', width: 60, height: 60, fit: BoxFit.cover,)
                          : Image.network(listTutoreds[index].profileImage, width: 60, height: 60, fit: BoxFit.cover,)
                      )
                  ],
                )),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      listTutoreds[index].matricula,
                      style: TextStyle(
                          color: const Color.fromRGBO(111, 12, 113, 1),
                          fontSize: fontSizeText),
                      textAlign: TextAlign.center,
                    )
                  ],
                )),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          procesarNombre(listTutoreds[index].fullname),
                          style: TextStyle(
                              color: const Color.fromRGBO(111, 12, 113, 1),
                              fontSize: fontSizeText),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: listTutoreds.length,
    );
  }
}
