import 'package:go_router/go_router.dart';
import 'package:transformation/ui/speed_screen.dart';
import 'package:transformation/ui/weight_screen.dart';
import 'ui/length_screen.dart';

final router = GoRouter(
  initialLocation: '/start',
  routes: [
    GoRoute(
      path: '/start',
      builder: (context, state) => const LengthScreen(),
      // routes: [
      //  안에 넣으면 연결
      // ]
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