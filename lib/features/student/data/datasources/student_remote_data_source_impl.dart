import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/datasources/student_data_source.dart';

class StudentRemoteDataSourceImpl implements StudentDataSource {
  final http.Client client;

  StudentRemoteDataSourceImpl({required this.client});
  
  @override
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss) async {
    const String url = 'https://devsolutions.software/api/v1/students/save-general-data';
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    final response = await client.post(
      Uri.parse(url), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({ 
        'userUUID': userUUID,
        'matricula': matricula,
        'group': group,
        'quarter': quarter,
        'phone_number': phoneNumer,
        'home_phone': homePhone,
        'nss': nss
      })
    );

    if(response.statusCode == 404) {
      throw Exception('Por favor inicia sesión nuevamente');
    }

    if(response.statusCode == 500) {
      throw Exception('Por favor contacta a soporte');
    }

  }
  
  @override
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning) async {
    const String url = 'https://devsolutions.software/api/v1/students/learning-style-responses';
    final String jwt = await SharedPreferencesServiceStudent.getToken();

    final response = await client.post(
      Uri.parse(url), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({ 
        'studentUUID': userUUID,
        'responses': typeLearning
      })
    );

    if(response.statusCode == 404) throw Exception('Error, vuelve a iniciar sesión o contacta a soporte.');

    if(response.statusCode == 500) throw Exception('Error, contacta a soporte.');

    await SharedPreferencesServiceStudent.setTypeLearning(true);
  }
  
  @override
  Future<String> vinculeTutor(String userUUID, String code) async {
    const String url = 'https://devsolutions.software/api/v1/students/verify-tutor-code/';
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    final response = await client.post(
      Uri.parse(url), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({ 
        'userUUID': userUUID,
        'tutorCode': code
      })
    );
    if(response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) throw 'Error, ingresa un código existente';

    final responseJson = jsonDecode(response.body);

    await SharedPreferencesServiceStudent.vinculeTutor(responseJson['haveTutor']);

    return responseJson['haveTutor'];
  }
  
  @override
  Future<String> getScheduleTutor(String tutorUUID) async {
    final String url = "https://devsolutions.software/api/v1/tutors/getScheduleImage/$tutorUUID";
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
    });

    final responseJson = jsonDecode(response.body);

    if(response.statusCode == 401) throw 'Inicia sesión nuevamente';

    if(response.statusCode != 200 || responseJson == null || responseJson['horario'] == 'PENDING') {
      throw 'Tú tutor aun no tiene un horario disponible';
    }


    return responseJson['horario'];
  }

}