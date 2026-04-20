import 'package:flutter/material.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/splash/splash_view.dart';
import '../views/auth/auth_view.dart';
import '../views/kos/kos_view.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
     case '/':
        return _noAnimation(LoginView(), settings);

      case '/login':
        return _noAnimation(AuthView(), settings);

      case '/register':
        return _noAnimation(RegisterView(), settings);

      case '/home':
        return _noAnimation(const HomeView(), settings);

      case '/kost':
        return _noAnimation(const KostView(), settings);

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