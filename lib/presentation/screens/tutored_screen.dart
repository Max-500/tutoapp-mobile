import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
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

class _Tutored extends ConsumerWidget {
  final TutoredModel tutored;

  const _Tutored({
    required this.tutored,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.035;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: Column(
          children: [
            SizedBox(
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                child: ClipOval(
                  child: tutored.profileImage == 'PENDING'
                      ? Image.asset('images/perfil.png',
                          width: 60, height: 60, fit: BoxFit.cover)
                      : Image.network(
                          tutored.profileImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                )),
            Text(
              'Matricula',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
              text: tutored.matricula,
              weight: FontWeight.w300,
              sizeHeight: screenHeight * 0.06,
              sizeWidth: screenWidth * 0.85,
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              'Nombre',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
                text: tutored.fullname,
                weight: FontWeight.w300,
                sizeHeight: screenHeight * 0.06,
                sizeWidth: screenWidth * 0.85),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              'Grado y grupo',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
                text: tutored.gradeAndGroup,
                weight: FontWeight.w300,
                sizeHeight: screenHeight * 0.06,
                sizeWidth: screenWidth * 0.85),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              'Número de telefono personal',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
                text: tutored.phoneNumer,
                weight: FontWeight.w300,
                sizeHeight: screenHeight * 0.06,
                sizeWidth: screenWidth * 0.85),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              'Número de telefono familiar',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
                text: tutored.homePhone,
                weight: FontWeight.w300,
                sizeHeight: screenHeight * 0.06,
                sizeWidth: screenWidth * 0.85),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              'Número de seguridad social',
              style: TextStyle(fontSize: fontSizeText),
              textAlign: TextAlign.center,
            ),
            LabeledContainer(
                text: tutored.nss,
                weight: FontWeight.w300,
                sizeHeight: screenHeight * 0.06,
                sizeWidth: screenWidth * 0.85),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final getPDF = ref.read(getPDFProvider);
                try {
                  await getPDF(tutored.matricula, tutored.fullname, tutored.gradeAndGroup[0], tutored.gradeAndGroup[1], tutored.phoneNumer, tutored.homePhone, tutored.nss);
                  showToastOk('Archivo guardado en: Download/${tutored.matricula}.pdf');
                } catch (e) {
                  showToast(e.toString());
                }
              },
              label: const Text(
                'Descargar',
                style: TextStyle(color: Colors.white), // Color del texto
              ),
              icon: const Icon(
                Icons.download, // Icono de descarga
                color: Colors.white, // Color del icono
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color.fromRGBO(111, 12, 113, 1), // Color del texto
                minimumSize:
                    const Size(150, 50), // Tamaño del botón (ancho, alto)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            SizedBox(
              height: screenHeight * 0.06,
              width: screenWidth * 0.25,
              child: ElevatedButtonCustomized(
                onPressed: () => context.pop(),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
