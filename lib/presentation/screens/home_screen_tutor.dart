// ignore_for_file: constant_pattern_never_matches_value_type, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
import 'package:tuto_app/widgets.dart';

class HomeScreenTutor extends ConsumerStatefulWidget {
  final String code;
 final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  HomeScreenTutor({super.key, required this.code});

  @override
  HomeScreenTutorState createState() => HomeScreenTutorState();
}

class HomeScreenTutorState extends ConsumerState<HomeScreenTutor> {
  bool _isProcessing = false;

  Future<void> getPremium(BuildContext context) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final paymentIntentData = await _createPaymentIntent();
      if (paymentIntentData == null) {
        _showDialog(context, 'Error', 'No se pudo crear la intención de pago, intentalo mas tarde.');
        return;
      }
      
      await _initializePaymentSheet(paymentIntentData['client_secret']);
      await _presentPaymentSheet(context, paymentIntentData);
    } catch (e) {
      _showDialog(context, 'Error', 'Error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent() async {
    Map<String, dynamic> body = {
      'amount': "7000", // Stripe expects the amount in the smallest currency unit (e.g., cents)
      'currency': 'MXN',
      'payment_method_types[]': 'card'
    };

    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
      headers: {
        'Authorization': 'Bearer sk_test_51PfNmwRpjXAqyBlMWNBgRaawFybJXwXbsq32sBwfsEzToCnsskbDXTJABXeUcZaeakO56NdEEX6p4s8uTPDhIvPy00i7f1glDO',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    print('Vengo de la api');
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: clientSecret,
        style: ThemeMode.system,
        merchantDisplayName: "DevSolutions",
      ),
    );
  }

  Future<void> _presentPaymentSheet(BuildContext context, Map<String, dynamic> paymentIntentData) async {
    try {
    await Stripe.instance.presentPaymentSheet();
      final paymentIntent = await Stripe.instance.retrievePaymentIntent(paymentIntentData['client_secret']);
      _handlePaymentIntentStatus(context, paymentIntent.status);
    } catch (e, _) {
      _handlePaymentSheetError(context, e);
    }
  }

  void _handlePaymentSheetError(BuildContext context, dynamic error) {
    if (error is StripeException) {
      switch (error.error.code) {
        case 'Canceled':
          _showDialog(context, 'Pago Cancelado', 'El pago ha sido cancelado.');
          break;
        default:
          _showDialog(context, 'Error', error.error.message ?? 'Ocurrió un error desconocido.');
      }
    } else {
      _showDialog(context, 'Error', 'Ocurrió un error desconocido.');
    }
  }

void _handlePaymentIntentStatus(BuildContext context, dynamic status) {
  switch (status) {
    case PaymentIntentsStatus.RequiresPaymentMethod:
      _showDialog(context, 'Método de Pago Requerido', 'El método de pago es inválido o no ha sido proporcionado. Por favor, intente con otro método.');
      break;
    case PaymentIntentsStatus.RequiresAction:
      _showDialog(context, 'Acción Requerida', 'Se requiere acción adicional para completar el pago.');
      break;
    case PaymentIntentsStatus.Processing:
      _showDialog(context, 'Procesando', 'Su pago está siendo procesado. Espere un momento.');
      break;
    case PaymentIntentsStatus.RequiresCapture:
      _showDialog(context, 'Captura Requerida', 'El pago necesita ser capturado manualmente.');
      break;
    case PaymentIntentsStatus.Canceled:
      _showDialog(context, 'Cancelado', 'El pago ha sido cancelado.');
      break;
    case PaymentIntentsStatus.Succeeded:
      _showDialog(context, 'Exitoso', 'El pago ha sido completado exitosamente.');
      break;
    default:
      _showDialog(context, 'Error', 'Estado de pago desconocido.');
  }
}

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'OK', onPressed: () {}),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color.fromRGBO(111, 12, 113, 1),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

    Future<void> refundPayment(String paymentIntentId) async {
    final refundResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/refunds'),
      body: {
        'payment_intent': paymentIntentId,
      },
      headers: {
        'Authorization': 'Bearer sk_test_51PfNmwRpjXAqyBlMWNBgRaawFybJXwXbsq32sBwfsEzToCnsskbDXTJABXeUcZaeakO56NdEEX6p4s8uTPDhIvPy00i7f1glDO',
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    );

    if (refundResponse.statusCode == 200) {
      print('Reembolso exitoso');
    } else {
      print('Error en el reembolso: ${refundResponse.body}');
    }
  }

  Future<List<TutoredModel>> getTutoreds() async {
      try {
        final getTutoreds = ref.read(getTutoredsProvider);
        return await getTutoreds();
      } catch (e){
        showToast(e.toString());
        return [];
      }
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.07;
    final double responsiveIcon = screenWidth * 0.07;

    return Scaffold(
      appBar: AppBar(
        key: widget.scaffoldKey,
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/icono.svg', height: 30),
              const SizedBox(width: 10),
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const SideMenu(isTutor: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeText)),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Codigo: ${widget.code}',
              iconButton: IconButton(
                icon: Icon(Icons.content_copy_outlined, size: responsiveIcon, color: const Color.fromRGBO(111, 12, 113, 1)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.code));
                  _showSnackbar(context, 'Copied to Clipboard');
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Tutorados',
              callback: () async {     
                final tutoreds = await getTutoreds();
                if (tutoreds.isEmpty) {
                  context.push('/list-tutoreds', extra: []);
                  return;
                }
                context.push('/list-tutoreds', extra: tutoreds);
              },
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Solicitudes de Permisos',
              callback: () {},
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Estadisticos de aprendizaje',
              callback: () {},
              isPro: true,
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Chat',
              callback: () async {
                await getPremium(context);
              },
              isPro: true,
            ),
          ],
        ),
      ),
    );
  }
}
