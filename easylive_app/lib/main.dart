import 'package:flutter/material.dart';

import 'models/history_model.dart';
import 'views/auth/auth_view.dart';
import 'views/auth/register_view.dart';
import 'views/booking/booking_view.dart';
import 'views/history/history_detail_view.dart';
import 'views/history/history_view.dart';
import 'views/home/home_view.dart';
import 'views/kos/kos_view.dart';
import 'views/profile/profile_view.dart';
import 'views/splash/splash_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: generateRoute,
    );
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _noAnimation(const SplashScreen(), settings);

      case '/login':
        return _noAnimation(AuthView(), settings);

      case '/register':
        return _noAnimation(RegisterView(), settings);

      case '/home':
        return _noAnimation(const HomeView(), settings);

      case '/kost':
        return _noAnimation(const KostView(), settings);

      case '/booking':
        return _noAnimation(const BookingView(), settings);

      case '/history':
        return _noAnimation(const HistoryView(), settings);

      case '/history/detail':
        final item = settings.arguments as HistoryItem;
        return _noAnimation(HistoryDetailView(item: item), settings);

      case '/profile':
        return _noAnimation(const ProfileView(), settings);

      default:
        return null;
    }
  }

  static PageRouteBuilder _noAnimation(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => page,
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
