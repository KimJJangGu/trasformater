import 'package:go_router/go_router.dart';
import 'package:transformation/presenter/speed/speed_screen.dart';
import 'package:transformation/presenter/weight/weight_screen.dart';
import 'presenter/length/length_screen.dart';

final router = GoRouter(
  initialLocation: '/start',
  routes: [
    GoRoute(
      path: '/start',
      builder: (context, state) => const LengthScreen(),
    ),
    GoRoute(
      path: '/start/weight',
      builder: (context, state) => const WeightScreen(),
    ),
    GoRoute(
      path: '/start/speed',
      builder: (context, state) => const SpeedScreen(),
    ),
  ],
);