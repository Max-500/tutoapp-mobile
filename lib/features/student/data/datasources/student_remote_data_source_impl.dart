import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/features/student/domain/datasources/student_data_source.dart';
import 'package:image_picker/image_picker.dart';

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
  
  @override
  Future<String> getProfileImage(String userUUID) async {
    final String url = "https://devsolutions.software/api/v1/auth/getProfileImage/$userUUID";
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    final responseJson = jsonDecode(response.body);

    if(response.statusCode != 200) {
      return responseJson['error']['message'];
    }
    final String image = responseJson['image'];
    return image.replaceAll(' ', '%20');
  }
  
  @override
  Future<String> permission(String userUUID, String tutorUUID) async {
    const String url = "https://devsolutions.software/api/v1/tutors/permissions";
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    },
    body: jsonEncode({ 
      'userUUID': userUUID,
      'tutorUUID': tutorUUID
     })
    );

    final responseJson = jsonDecode(response.body);

    if(response.statusCode == 200) return 'Permiso solicitado correctamente';

    throw responseJson['message'];
  }

  @override
  Future<String> updateProfileImage(String userUUID, XFile file) async {
    final String url = "https://devsolutions.software/api/v1/auth/updateprofileImage/$userUUID";
    final String jwt = await SharedPreferencesServiceStudent.getToken();
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $jwt';

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();

      var multipartFile = http.MultipartFile('file', stream, length, filename: basename(file.path));
      request.files.add(multipartFile);

      final response = await request.send();
      final responseJson = await http.Response.fromStream(response);
      final parsedJson = json.decode(responseJson.body);
      if(response.statusCode == 200) {
        final String image = parsedJson['s3ObjectUrl'];
        return image.replaceAll(' ', '%20');
      }

      final String error = parsedJson['error']['message'];
      throw error.replaceAll('Tutor', 'User');
    } catch (e) {
      throw e.toString();
    }
  }

}