import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/tutor/domain/datasources/tutor_data_source.dart';

class TutorRemoteDataSourceImpl implements TutorDatasource {
  final http.Client client;

  TutorRemoteDataSourceImpl({required this.client});

  @override
  Future<String> getCode(String userUUID) async {
    final String url = 'https://devsolutions.software/api/v1/tutors/getCode/$userUUID';
    
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    final responseJson = jsonDecode(response.body);

    if(response.statusCode == 200) {
      return responseJson['code'];
    }
    throw Exception('Inicia Sesión Nuevamente');
  }

}