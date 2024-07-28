import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/features/tutor/domain/datasources/tutor_data_source.dart';
import 'package:path/path.dart';

class TutorRemoteDataSourceImpl implements TutorDatasource {
  final http.Client client;

  TutorRemoteDataSourceImpl({required this.client});

  @override
  Future<String> getCode(String userUUID) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    final String url = 'https://devsolutions.software/api/v1/tutors/getCode/$userUUID';
    
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );
    final responseJson = jsonDecode(response.body);

    if(response.statusCode == 200) {
      return responseJson['code'];
    }
    throw Exception('Inicia Sesión Nuevamente');
  }
  
  @override
  Future<void> becomePremium(String userUUID, String transactionId) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    const String url = "https://devsolutions.software/api/v1/payments/";

    try {
      DateTime now = DateTime.now();
      String isoDate = now.toIso8601String();

      final response = await http.post(Uri.parse(url), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({ 
          "userUUID": userUUID,
          "amount": 70,
          "currency": "MXN",
          "paymentMethod": "card",
          "transactionId": transactionId,
          "date": isoDate
         })
      );

      if(response.statusCode == 422) {
        throw 'Por favor intentalo mas tarde';
      }

      if(response.statusCode == 400) {
        throw 'Actualmente tienes una suscripción premium activa';
      }

      if(response.statusCode == 500) {
        throw 'Algo sucedio mal y se hizo el rembolso del pago, por favor contacta a soporte';
      }

    } catch(e) {
      throw e.toString();
    }
  }

  @override
  Future<List<TutoredModel>> getTutoreds(String userUUID) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    try {
      const String url = "https://devsolutions.software/api/v1/tutors/get-tutoreds";

      final response = await http.post(
        Uri.parse(url),       
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({ 'userUUID': userUUID })
      );
 
      if(response.statusCode != 200) {
        throw 'Contacta a soporte';
      }
      
      final List<dynamic> responseJson = jsonDecode(response.body);

      return responseJson.map((tutored) => TutoredModel.fromJson(tutored)).toList();
    } catch (e) {
      throw 'Contacta a soporte';
    }
  }
  
  @override
  Future cancelOrder(String transactionId) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    const String url = "https://devsolutions.software/api/v1/payments/cancel-order";
    final response = await http.delete(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({ 'transactionId': transactionId })
    );

    if(response.statusCode != 204) {
      throw {
        'Error al cancelar el pago, por favor contacta a soporte'
      };
    }
  }
  
  @override
  Future getOrder() async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    const String url ="https://devsolutions.software/api/v1/payments/create-order";
    final response = await http.post(Uri.parse(url), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({ 
        "amount": 7000,
        "currency": "MXN"
      })
    );

    if(response.statusCode != 200) {
      throw 'Error al crear la orden de pago, intentalo mas tarde';
    }
    return jsonDecode(response.body);
  }
  
  @override
  Future<bool> isPremium(String userUUID) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    const String url = "https://devsolutions.software/api/v1/payments/verify-premium";
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({ 'userUUID': userUUID })
    );

    if(response.statusCode == 204) return true;

    return false;
  }
  
  @override
  Future<String> updateSchedule(String userUUID, XFile file) async {
    final String jwt = await SharedPreferencesServiceTutor.getToken();

    try {
      final String url = "https://devsolutions.software/api/v1/tutors/updateScheduleImage/$userUUID";

      final request = http.MultipartRequest('PUT', Uri.parse(url));

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();

      // Agrega el archivo al formulario
      var multipartFile = http.MultipartFile('file', stream, length, filename: basename(file.path));
      request.files.add(multipartFile);

      final response = await request.send();

      if(response.statusCode == 200) {
        return "Se ha actualizado tu horario";
      }

      final responseJson = await http.Response.fromStream(response);
      final parsedJson = json.decode(responseJson.body);
      throw parsedJson["error"]["message"];

    } catch (e) {
      throw 'Error: ${e.toString()}';
    }
  }

}