import 'package:easylive_app/views/booking/booking_view.dart';
import 'package:flutter/material.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/splash/splash_view.dart';
import '../views/auth/auth_view.dart';
import '../views/kos/kos_view.dart';
import '../views/booking/booking_view.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _noAnimation(SplashScreen(), settings);

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
      case '/wallet':
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Wallet')),
            body: Center(child: Text('Wallet View - Coming Soon')),
          ),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(child: Text('Profile View - Coming Soon')),
          ),
        );
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
