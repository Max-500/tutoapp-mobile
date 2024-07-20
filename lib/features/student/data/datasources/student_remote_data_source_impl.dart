import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tuto_app/features/student/domain/datasources/student_data_source.dart';

class StudentRemoteDataSourceImpl implements StudentDataSource {
    final http.Client client;

  StudentRemoteDataSourceImpl({required this.client});
  
  @override
  Future<void> saveDataGeneral(String userUUID, String matricula, String group, String quarter, String phoneNumer, String homePhone, String nss) async {
    const String url = 'https://devsolutions.software/api/v1/students/save-general-data';
    final response = await client.post(
      Uri.parse(url), 
      headers: {'Content-Type': 'application/json'},
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
  Future<void> saveTypeLearning(String userUUID, List<String> typeLearning) {
    // TODO: implement saveTypeLearning
    throw UnimplementedError();
  }
  
  @override
  Future vinculeTutor(String userUUID, String code) {
    // TODO: implement vinculeTutor
    throw UnimplementedError();
  }

}