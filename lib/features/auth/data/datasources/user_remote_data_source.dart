import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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
      Uri.parse('http://34.235.78.124:3000/api/v1/auth/register'),
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
      Uri.parse('http://34.235.78.124:3000/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }
}
