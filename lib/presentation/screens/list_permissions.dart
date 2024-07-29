// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_permission_model.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
import 'package:tuto_app/widgets.dart';

class ListPermissions extends ConsumerStatefulWidget {
  final globalKey = GlobalKey<ScaffoldState>();

  ListPermissions({super.key});

  @override
  _ListPermissionsState createState() => _ListPermissionsState();
}

class _ListPermissionsState extends ConsumerState<ListPermissions> {
  bool isLoaging = false;

  late List<TutoredPermissionModel> tutoreds = [];

  @override
  void initState() {
    setState(() {isLoaging = true;});
    super.initState();
    loadData();
    setState(() {isLoaging = false;});
  }

  Future<void> loadData() async {
    final getTutoredsPermission = ref.read(getTutoredsPermissionProvider);
    tutoreds = await getTutoredsPermission();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarListPermissions(screenWidth: screenWidth),
      ),
      key: widget.globalKey,
      drawer: SideMenu(
        isTutor: true,
        globalKey: widget.globalKey,
      ),
      body: 
      isLoaging ? const CircularProgressIndicator() :
      Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.025,
            ),
            Expanded(
                child: _ListTuroredsPermissions(
              listTutoreds: tutoreds,
            )),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.075),
              child: SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.25,
                child: ElevatedButtonCustomized(
                  onPressed: () async {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.arrow_back, // Icono de flecha hacia la izquierda
                    color: Colors.white, // Color del icono
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppBarListPermissions extends StatelessWidget {
  const AppBarListPermissions({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Solicitudes de Permisos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ListTuroredsPermissions extends StatelessWidget {
  final List<TutoredPermissionModel> listTutoreds;

  const _ListTuroredsPermissions({required this.listTutoreds});

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
        final tutored = listTutoreds[index];
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
          height: screenHeight * 0.15,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(217, 217, 217, 0.7),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tutored.matricula,
                      style: TextStyle(
                        color: const Color.fromRGBO(111, 12, 113, 1),
                        fontSize: fontSizeText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      tutored.fecha,
                      style: TextStyle(
                        color: const Color.fromRGBO(111, 12, 113, 1),
                        fontSize: screenWidth * 0.03,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        procesarNombre(tutored.fullname),
                        style: TextStyle(
                          color: const Color.fromRGBO(111, 12, 113, 1),
                          fontSize: fontSizeText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listTutoreds.length,
    );
  }
}
