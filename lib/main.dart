import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/presentation/screens/home_screen_tutor.dart';
import 'package:tuto_app/presentation/screens/home_student_screen.dart';
import 'package:tuto_app/presentation/screens/type_learning_screen.dart';
import 'package:tuto_app/screens.dart';
import 'package:tuto_app/config/theme/app_theme.dart';

Future<String> getInitialLocation() async {
  final tutorPrefs = await SharedPreferencesServiceTutor.getUser();
  final studentPrefs = await SharedPreferencesServiceStudent.getStudent();

  return '/home-student';

  if (tutorPrefs['uuid'] != null && tutorPrefs['uuid'] != 'user_uuid') {
    final code = tutorPrefs['code'];
    return '/home-tutor/$code';
  }

  if (studentPrefs['userUUID'] == null || studentPrefs['userUUID'] == 'user_uuid') return '/';

  if (studentPrefs['generalData'] == null || studentPrefs['generalData'] == 'general_data' || !studentPrefs['generalData']) return '/general-data';

  if (studentPrefs['typeLearning'] == null || studentPrefs['typeLearning'] == 'type_learning' || !studentPrefs['typeLearning']) return '/welcome';

  if (studentPrefs['haveATutor'] == null || studentPrefs['haveATutor'] == 'have_tutor' || studentPrefs['haveATutor'] == 'PENDING') return '/link-code';

  return '/';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialLocation = await getInitialLocation();
  Stripe.publishableKey = 'pk_test_51PfNmwRpjXAqyBlMs1vE20bKvXKbzhwvPn1jzAtN2HN6hN6SYOc7FcX1Xy1ZMmtzzaSCLD5Xos8YeJ3jdWlaJV2u00t2jqFiJH';
  await Stripe.instance.applySettings();

  runApp(ProviderScope(child: MyApp(initialLocation: initialLocation)));
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
        GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/link-code', builder: (context, state) => const LinkCodeScreen()),
        GoRoute(path: '/home-tutor/:code', builder: (context, state) => HomeScreenTutor(code: state.pathParameters['code']!)),
        GoRoute(path: '/general-data', builder: (context, state) => GeneralDataScreen()),
        GoRoute(path: '/type-learning/:page', builder: (context, state) => TypeLearningScreen(currentPage: int.tryParse(state.pathParameters['page'] ?? '1') ?? 1)),
        GoRoute(path: '/home-student', builder: (context, state) => const HomeStudentScreen()),
        GoRoute(path: '/acknowledgment', builder: (context, state) => const Ackowledgment()),
        GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
        GoRoute(path: '/list-tutoreds', builder: (context, state) {
          final tutoreds = state.extra as List<TutoredModel>? ?? [];
          return TutoredsListScreen(tutoreds: tutoreds);
        }),
        GoRoute(path: '/tutored', builder: (context, state) {
          final tutored = state.extra as TutoredModel;
          return TutoredScreen(tutored: tutored,);
        } ,)
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}
