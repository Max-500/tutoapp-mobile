import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/screens.dart';
import 'package:tuto_app/config/theme/app_theme.dart';
import 'package:tuto_app/widgets.dart';

Future<String> getInitialLocation() async {
  final tutorPrefs = await SharedPreferencesServiceTutor.getUser();
  if(tutorPrefs['uuid'] != null) {
    final code = tutorPrefs['code'];
    return '/home-tutor/$code';
  }

  final studentPrefs = await SharedPreferencesServiceStudent.getStudent();
  if(studentPrefs['userUUID'] == null || studentPrefs['userUUID'] == 'user_uuid') {
    return '/';
  }

  if(studentPrefs['generalData'] == null || studentPrefs['generalData'] == 'general_data') {
    return '/general-data';
  }

  return '/';
}


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final initialLocation = await getInitialLocation();
    runApp(ProviderScope(child: MyApp(initialLocation: initialLocation,)));
}

class MyApp extends StatelessWidget {
  final String initialLocation;

  const MyApp({
    super.key, required this.initialLocation,
  });

  @override
  Widget build(BuildContext context) {
    final GoRouter appRouter = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginScreen(),),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen(),),
        GoRoute(path: '/link-code', builder: (context, state) => const LinkCodeScreen(),),
        GoRoute(path: '/home-tutor/:code', builder: (context, state) => HomeScreenTutor(code: state.pathParameters['code']!,),),
        GoRoute(path: '/general-data', builder: (context, state) => GeneralDataScreen(),),
        GoRoute(path: '/type-learning', builder: (context, state) => const TypeLearningScreen(),),
        GoRoute(path: '/home-student', builder: (context, state) => const HomeStudentScreen(),)
      ]
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}