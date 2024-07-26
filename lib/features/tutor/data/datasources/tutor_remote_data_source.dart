import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
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
  
  @override
  Future<void> getPremium(BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        'amount': "70",
        'currency': 'MXN',
        'payment_method_types_[]': 'card'
      };

      final response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51PfNmwRpjXAqyBlMWNBgRaawFybJXwXbsq32sBwfsEzToCnsskbDXTJABXeUcZaeakO56NdEEX6p4s8uTPDhIvPy00i7f1glDO',
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      );

      var paymentIntentData = jsonDecode(response.body);
      
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        style: ThemeMode.system,
        merchantDisplayName: "DevSolutions"
      ));
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if(kDebugMode) {
          print('Error: $error, $stackTrace');
          showDialog(context: context, builder: (_) => const AlertDialog(
            title: Text('Cancelled'),
          ),);
        }
      });
    } on StripeException catch (e) {

        if(kDebugMode) {
          print("Soy StripeException: $e");
        }
    } catch (e, s) {
      if(kDebugMode) {
        print(s);
      }
    }

  }

  @override
  Future<List<TutoredModel>> getTutoreds(String userUUID) async {
    try {
      const String url = "https://devsolutions.software/api/v1/tutors/get-tutoreds";

      final response = await http.post(
        Uri.parse(url),       
        headers: {'Content-Type': 'application/json'},
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

}