// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';
import 'package:tuto_app/widgets.dart';

class UpdateProfileStudent extends ConsumerStatefulWidget {
  final String profileImage;

  const UpdateProfileStudent({super.key, required this.profileImage});

  @override
  _UpdateProfileStudentState createState() => _UpdateProfileStudentState();
}

class _UpdateProfileStudentState extends ConsumerState<UpdateProfileStudent> {
  late String url;
  bool isLoading = false;
  static final formKey = GlobalKey<FormState>();

  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profileImage == "Profile-image-not-found") {
      url = "profile-image-not-found";
    } else {
      url = widget.profileImage;
    }
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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.06;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarUpdateProfileImage(
          screenWidth: screenWidth,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.075),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('https://tutoapp-spaces.nyc3.digitaloceanspaces.com/$url'),
                    ),
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
                OutlinedButton.icon(
                  onPressed: () async {
                    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    try {
                      if (file == null) return;
                      setState(() {isLoading = true;});
                      final updateProfileImage = ref.read(updateProfileImageProvider);
                      url = await updateProfileImage(file);
                      isLoading = false;
                      showToastOk('Se ha actualizado correctamente la foto de perfil');
                      setState(() {});
                    } catch (e) {
                      setState(() {isLoading = false;});
                      showToast(e.toString());
                    }
                  },
                  label: const Text(
                    'Cambiar foto de perfil',
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.black,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent), // Sin borde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Ajustar el borde a tu preferencia
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Actualizar telefono personal'),
                          ],
                        ),
                        TextFormFieldCustomized(
                          hintText: 'Telefono Personal',
                          controller: phoneController,
                          validator: validateMobilePhone,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text('Actualizar telefono familiar')],
                        ),
                        TextFormFieldCustomized(
                          hintText: 'Telefono Familiar',
                          controller: telephoneController,
                          validator: validateHomePhone,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.07,
                              child: ElevatedButtonCustomized(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  formKey.currentState!.save();
                                  try {
                                    final student = await SharedPreferencesServiceStudent.getStudent();
                                    final saveDataGeneral = ref.read(saveDataGeneralProvider);
                                    await saveDataGeneral(student['userUUID'], '213497', 'A', '9', phoneController.text, telephoneController.text, '12345678901');
                                    context.pop();
                                    showToastOk("Se ha actualizado correctamente tu información");
                                  } catch (e) {
                                    showToast(e.toString().replaceFirst('Exception ', ''));
                                  }
                                },
                                child: Text(
                                  'Actualizar',
                                  style: TextStyle(color: Colors.white, fontSize: fontSizeText),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarUpdateProfileImage extends StatelessWidget {
  final double screenWidth;

  const AppBarUpdateProfileImage({
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
            'Perfil',
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