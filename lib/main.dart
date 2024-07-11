import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/shared_preferences_service.dart';
import 'package:tuto_app/screens.dart';
import 'package:tuto_app/config/theme/app_theme.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final String userUUID = prefs.getString('user_uuid') ?? '';
    final String userRole = prefs.getString('user_role') ?? '';
    final String haveATutor = prefs.getString('is_student_and_have_a_tutor') ?? '';
    

    runApp(ProviderScope(child: MyApp(userRole: userRole, userUUID: userUUID, haveATutor: haveATutor,)));
}

class MyApp extends StatelessWidget {
  final String userUUID;
  final String userRole;
  final String haveATutor;

  const MyApp({super.key, required this.userUUID, required this.userRole, required this.haveATutor});

  @override
  Widget build(BuildContext context) {
    final GoRouter appRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginScreen(),),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen(),),
        GoRoute(path: '/link-code', builder: (context, state) => const LinkCodeScreen(),),
        GoRoute(path: '/home-tutor', builder: (context, state) => const HomeScreenTutor(),)
      ],
      redirect: (BuildContext context, GoRouterState state) {
        if(userUUID == ''){
          return '/';
        }
        if (userRole == 'tutor') {
            return '/home-tutor';
          } 
        if (haveATutor == 'YES') {
          return '/home-student';
        }
        return '/link-code';
      }
        
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }

}