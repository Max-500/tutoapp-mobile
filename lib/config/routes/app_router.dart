import 'package:go_router/go_router.dart';
import 'package:tuto_app/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen(),),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen(),),
    GoRoute(path: '/link-code', builder: (context, state) => const LinkCodeScreen(),)
  ]
);