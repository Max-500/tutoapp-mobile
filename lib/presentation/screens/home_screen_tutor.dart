// ignore_for_file: constant_pattern_never_matches_value_type, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
import 'package:tuto_app/widgets.dart';

class HomeScreenTutor extends ConsumerStatefulWidget {
  final globalKey = GlobalKey<ScaffoldState>();

  final String code;

  HomeScreenTutor({super.key, required this.code});

  @override
  HomeScreenTutorState createState() => HomeScreenTutorState();
}

class HomeScreenTutorState extends ConsumerState<HomeScreenTutor> {
  late bool isPremium = false;
  bool _isProcessing = false;

  final noScreenShot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    isPremumInitializer();
    noScreenShot.screenshotOff();
  }

  @override
  void dispose() {
    noScreenShot.screenshotOn();
    super.dispose();
  }

  Future<void> _enableSecureScreen() async {
    await noScreenShot.screenshotOff();
  }

  Future<void> _disableSecureScreen() async {
    await noScreenShot.screenshotOn();
  }

  Future<void> isPremumInitializer() async {
    final isPremiumData = ref.read(isPremiumProvider);
    isPremium = await isPremiumData();
    setState(() {});
  }

  Future<void> becomePremium(BuildContext context) async {
    _enableSecureScreen();
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final getOrder = ref.read(getOrderPaymentProvider);
    final paymentIntentData = await getOrder();

    try {
      if (paymentIntentData == null) {
        _showDialog(context, 'Error', 'No se pudo crear la intención de pago, intentalo mas tarde.');
        return;
      }
      
      await _initializePaymentSheet(paymentIntentData['client_secret']);
      await _presentPaymentSheet(context, paymentIntentData);
      _disableSecureScreen();
    } catch (e) {
      final cancelOrder = ref.read(cancelOrderPaymentProvider);
      await cancelOrder(paymentIntentData['id']!);
      _showDialog(context, 'Error', 'Error: $e');
      
    } finally {
      setState(() {
        _isProcessing = false;
      });
      _disableSecureScreen(); // Ensure to disable secure screen in the finally block
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
      _handlePaymentIntentStatus(context, paymentIntent.status, paymentIntentData['id']);
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

void _handlePaymentIntentStatus(BuildContext context, dynamic status, dynamic transactionId) async {
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
      try {
        final getPremium = ref.read(savePaymentProvider);
        await getPremium(transactionId);
        _showDialog(context, 'Exitoso', 'El pago ha sido completado exitosamente.');
      } catch (e) {
        _showSnackbar(context, e.toString());
      }        
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
              context.pop();
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
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(snackBar);
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
    print(isPremium);
    
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double fontSizeText = screenWidth * 0.07;
    final double responsiveIcon = screenWidth * 0.07;

    XFile? file;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarTutor(screenWidth: screenWidth),
      ),
      key: widget.globalKey,
      drawer: SideMenu(isTutor: true, globalKey: widget.globalKey,),
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
              callback: () => context.push('/list-tutoreds-permissions'),
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(
              text: 'Actualizar Horario',
              callback: () async {
                file = await ImagePicker().pickImage(source: ImageSource.gallery);
                if(file == null) return;
                try {
                  final updateSchedule = ref.read(updateScheduleProvider);
                  showToastOk(await updateSchedule(file!));
                } catch (e) {
                  showToast(e.toString());
                }
              },
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(text: 'Estadisticos de aprendizaje', callback: () async {
              if(!isPremium) {
                  await becomePremium(context);
                  return;
              }
              context.push("/results-type-learning");
            },
              isPro: true,
            ),
            SizedBox(height: screenHeight * 0.05),
            LabeledContainer(text: 'Chat', callback: () async {
                if(!isPremium) {
                  await becomePremium(context);
                  return;
                }
              },
              isPro: true,
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarTutor extends StatelessWidget {
  const AppBarTutor({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
