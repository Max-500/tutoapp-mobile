import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';

abstract class UserRemoteDataSource  {
  Future<dynamic> register(Map<String, dynamic> userRegistrationData);
  Future<dynamic> login(String email, String password);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<dynamic> register(Map<String, dynamic> userRegistrationData) async {
    final response = await client.post(
      Uri.parse('https://devsolutions.software/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userRegistrationData),
    );

    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if(response.statusCode == 409){
      throw 'The email is already registered, try another one.';
    } else if(response.statusCode == 422){
      throw responseJson['validations'][0]['errorMessages'][0];
    } else{
      throw 'Failed to register user';
    }
  }

  @override
  Future<dynamic> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('https://devsolutions.software/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    final responseJson = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      if(responseJson['user']['student'] != null){
        await SharedPreferencesServiceStudent.saveStudent(responseJson['user']['student']['userUUID'], responseJson['user']['student']['haveTutor'], responseJson['user']['generalDataBool'], responseJson['user']['typeLearningBool']);
        return responseJson;
      }
      await SharedPreferencesServiceTutor.saveUser(responseJson['user']['uuid']);
      return responseJson;
    } else if (response.statusCode == 401 || response.statusCode == 404){
      final String message = responseJson['message'] == 'Invalid password' ? responseJson['message'] : 'The user does not exists.';
      throw Exception(message);
    } else {
      throw Exception('Failed to login');
    }
  }
}
