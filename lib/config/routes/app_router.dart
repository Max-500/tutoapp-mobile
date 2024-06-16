import 'package:go_router/go_router.dart';
import 'package:tuto_app/presentation/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen(),)
  ]
);