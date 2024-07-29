import 'package:tuto_app/features/tutor/domain/repositories/tutor_repository.dart';

class GetPdf {
  final TutorRepository repository;

  GetPdf({required this.repository});

  Future call(String matricula, String nombre, String grado, String grupo, String phone, String telephone, String nss) async {
    await repository.getPDF(matricula, nombre, grado, grupo, phone, telephone, nss);
  }
}